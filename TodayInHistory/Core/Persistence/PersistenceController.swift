import CoreData

final class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "TodayInHistory")

        container.loadPersistentStores { description, error in
            if let error = error {
                Logger.log("CoreData failed to load: \(error)", level: .error)
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Cache Facts

    func cacheFacts(_ facts: [Fact]) async {
        let context = container.newBackgroundContext()

        await context.perform {
            for fact in facts {
                let cached = CachedFact(context: context)
                cached.id = fact.id
                cached.date = fact.date
                cached.region = fact.region.rawValue
                cached.setNumber = Int16(fact.setNumber)
                cached.topic = fact.topic
                cached.title = fact.title
                cached.summary = fact.summary
                cached.fullContent = fact.fullContent
                cached.imageURL = fact.imageUrl
                cached.sourceURL = fact.sourceUrl
                cached.cachedAt = Date()
            }

            do {
                try context.save()
            } catch {
                Logger.log("Failed to cache facts: \(error)", level: .error)
            }
        }
    }

    // MARK: - Retrieve Cached Facts

    func getCachedFacts(for date: Date) -> [Fact] {
        let request: NSFetchRequest<CachedFact> = CachedFact.fetchRequest()

        // Match date (ignoring time)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CachedFact.region, ascending: true)
        ]

        do {
            let cached = try container.viewContext.fetch(request)
            return cached.compactMap { $0.toFact() }
        } catch {
            Logger.log("Failed to fetch cached facts: \(error)", level: .error)
            return []
        }
    }

    // MARK: - Prune Old Cache

    func pruneOldCache() async {
        let context = container.newBackgroundContext()
        let cutoffDays = Config.API.cacheDurationDays
        let cutoff = Calendar.current.date(byAdding: .day, value: -cutoffDays, to: Date())!

        await context.perform {
            let request: NSFetchRequest<NSFetchRequestResult> = CachedFact.fetchRequest()
            request.predicate = NSPredicate(format: "cachedAt < %@", cutoff as NSDate)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                Logger.log("Failed to prune cache: \(error)", level: .error)
            }
        }
    }

    // MARK: - Clear All Cache

    func clearAllCache() async {
        let context = container.newBackgroundContext()

        await context.perform {
            let request: NSFetchRequest<NSFetchRequestResult> = CachedFact.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                Logger.log("Failed to clear cache: \(error)", level: .error)
            }
        }
    }
}

// MARK: - CachedFact Entity

// This would be defined in TodayInHistory.xcdatamodeld
// For reference, the entity would have these attributes:
//
// CachedFact:
//   - id: UUID
//   - date: Date
//   - region: String
//   - setNumber: Int16
//   - topic: String
//   - title: String
//   - summary: String
//   - fullContent: String
//   - imageURL: String?
//   - sourceURL: String
//   - cachedAt: Date

extension CachedFact {
    func toFact() -> Fact? {
        guard let id = id,
              let date = date,
              let regionString = region,
              let region = Region(rawValue: regionString),
              let topic = topic,
              let title = title,
              let summary = summary,
              let fullContent = fullContent,
              let sourceURL = sourceURL else {
            return nil
        }

        return Fact(
            id: id,
            date: date,
            region: region,
            setNumber: Int(setNumber),
            topic: topic,
            title: title,
            summary: summary,
            fullContent: fullContent,
            imageUrl: imageURL,
            sourceUrl: sourceURL,
            createdAt: cachedAt ?? Date()
        )
    }
}

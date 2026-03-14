# TestFlight Deployment Guide

Get Today In History running on your phone via TestFlight.

---

## Prerequisites Checklist

- [ ] Apple Developer Account ($99/year)
- [ ] Xcode 15+ installed
- [ ] Supabase project created
- [ ] SQL schema deployed to Supabase *(you've done this)*

---

## Step 1: Create Xcode Project

1. **Open Xcode** → File → New → Project
2. Select **iOS → App**
3. Configure:
   - Product Name: `TodayInHistory`
   - Team: Your Apple Developer Team
   - Organization Identifier: `com.yourcompany` (or your domain reversed)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None** (we add CoreData manually)

4. Set **iOS Deployment Target: 15.0**
   - Select project in navigator → Target → General → Minimum Deployments → iOS 15.0

---

## Step 2: Import Code Files

1. In Finder, navigate to `/Users/kyleheery/Desktop/Today-In-History/TodayInHistory/`

2. Drag these folders into your Xcode project navigator:
   - `App/`
   - `Features/`
   - `Core/`
   - `Shared/`
   - `UI/`
   - `Resources/`

3. When prompted:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to target: TodayInHistory

---

## Step 3: Add Swift Packages

1. File → Add Package Dependencies

2. Add these packages:

| Package URL | Version |
|------------|---------|
| `https://github.com/supabase/supabase-swift` | 2.0.0+ |
| `https://github.com/onevcat/Kingfisher` | 7.0.0+ |
| `https://github.com/getsentry/sentry-cocoa` | 8.0.0+ |

3. Add all products to your target.

---

## Step 4: Configure Capabilities

1. Select your target → **Signing & Capabilities**

2. Click **+ Capability** and add:
   - **Sign in with Apple**
   - **Background Modes** → check "Background fetch"
   - **Push Notifications** (optional, for daily reminders)

---

## Step 5: Set Up CoreData

1. The CoreData model is at:
   `Resources/TodayInHistory.xcdatamodeld/TodayInHistory.xcdatamodel/contents`

2. In Xcode: File → New → File → **Data Model**
3. Name it `TodayInHistory`
4. Add entity `CachedFact` with these attributes:

| Attribute | Type |
|-----------|------|
| id | UUID |
| date | Date |
| region | String |
| setNumber | Integer 16 |
| topic | String |
| title | String |
| summary | String |
| fullContent | String |
| imageURL | String (Optional) |
| sourceURL | String |
| cachedAt | Date |

5. Set Codegen to **Class Definition**

---

## Step 6: Add Asset Colors

In **Assets.xcassets**, create Color Sets:

| Name | Light | Dark |
|------|-------|------|
| Background | #FFFFFF | #000000 |
| CardBackground | #F5F5F5 | #1C1C1E |
| PrimaryText | #000000 | #FFFFFF |
| SecondaryText | #666666 | #8E8E93 |
| Accent | #007AFF | #007AFF |
| ProGold | #FFD700 | #FFD700 |
| NorthAmerica | #3B82F6 | #3B82F6 |
| Europe | #6366F1 | #6366F1 |
| Asia | #EF4444 | #EF4444 |
| Africa | #F97316 | #F97316 |
| SouthAmerica | #22C55E | #22C55E |

---

## Step 7: Configure StoreKit (Local Testing)

1. Copy `Resources/TodayInHistory.storekit` into your project
2. Edit Scheme → Run → Options → StoreKit Configuration → Select `TodayInHistory.storekit`

This lets you test purchases locally without App Store Connect setup.

---

## Step 8: Build & Run Locally

1. Select your iPhone or Simulator
2. Press **⌘R** to build and run
3. App should launch with onboarding

---

## Step 9: Archive for TestFlight

1. Select **Any iOS Device (arm64)** as build target
2. Product → **Archive**
3. Wait for archive to complete
4. In Organizer: **Distribute App** → **TestFlight & App Store** → Upload

---

## Step 10: App Store Connect Setup

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. My Apps → **+** → New App
3. Fill in:
   - Platform: iOS
   - Name: Today In History
   - Primary Language: English
   - Bundle ID: Select your app's bundle ID
   - SKU: `todayinhistory001`

---

## Step 11: TestFlight Configuration

1. In App Store Connect → Your App → **TestFlight**
2. Under "Test Information":
   - Beta App Description: "Daily historical facts from around the world"
   - Feedback Email: your email
3. Add yourself as Internal Tester
4. Once build processes (~15 min), you'll get TestFlight invite

---

## Step 12: Install on Your Phone

1. Download **TestFlight** app from App Store (if not installed)
2. Open TestFlight → Accept invite
3. Install Today In History
4. 🎉 Done!

---

## Iteration Workflow

After making changes:

1. Increment build number in Xcode (Target → General → Build)
2. Product → Archive
3. Upload to App Store Connect
4. New build appears in TestFlight (~15 min)
5. TestFlight auto-updates or tap "Update" in TestFlight app

---

## Common Issues

### "No provisioning profile"
- Xcode → Preferences → Accounts → Download Manual Profiles
- Or: Target → Signing → Enable "Automatically manage signing"

### "Missing Push Notification Entitlement"
- Add Push Notifications capability (Step 4)
- Or remove notification-related code for v1

### "StoreKit products not loading"
- Ensure StoreKit config is selected in scheme
- For TestFlight: products must be created in App Store Connect

### Build fails on CoreData
- Ensure `CachedFact` entity codegen is "Class Definition"
- Clean build folder: Product → Clean Build Folder (⌘⇧K)

---

## REMINDER: Enable pg_cron

After your first successful TestFlight test, go to Supabase:

1. Dashboard → Database → Extensions
2. Enable `pg_cron`
3. Go to SQL Editor and run the commented cron job setup from your schema:

```sql
SELECT cron.schedule(
  'generate-daily-facts',
  '0 0 * * *',
  $$SELECT net.http_post(
    url := 'https://ewjpdmuloojbxypqscqp.supabase.co/functions/v1/generate-facts',
    headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
  )$$
);
```

This generates fresh facts daily at midnight UTC.

---

*Guide generated by Hogwarts Framework*

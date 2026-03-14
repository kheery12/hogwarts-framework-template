// Today In History - Weekly Fact Generation Edge Function
// Function name kept as "generate-facts" for backwards compatibility.
// Logic: generates content for the next 8 days (tomorrow through tomorrow+7).
// Intended to run every Sunday at 06:00 UTC via pg_cron, but can be
// triggered manually with optional query params:
//   ?days=8          (default 8)
//   ?startDate=YYYY-MM-DD  (default tomorrow)

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const REGIONS = ['north_america', 'europe', 'asia', 'africa', 'south_america'] as const

type Region = typeof REGIONS[number]
type Topic = 'sports' | 'history' | 'politics' | 'entertainment' | 'science' | 'technology' | 'social_movements' | 'military'

interface WikipediaEvent {
  year: number
  text: string
  pages: Array<{
    title: string
    extract?: string
    thumbnail?: { source: string }
    content_urls?: { desktop: { page: string } }
  }>
}

interface GeneratedFact {
  date: string
  region: Region
  set_number: number
  topic: Topic
  title: string
  summary: string
  full_content: string
  image_url: string | null
  source_url: string
  review_status: 'approved'
}

// -----------------------------------------------------------------------
// Region configuration (keywords + negative patterns)
// Keep this logic as-is - it's well-tuned for Wikipedia filtering.
// -----------------------------------------------------------------------

const REGION_CONFIG: Record<Region, {
  keywords: string[]
  negativePatterns: string[]
}> = {
  north_america: {
    keywords: [
      'United States', 'USA', 'U.S.', 'Canada', 'Mexico',
      'American', 'Canadian', 'Mexican',
      'New York', 'Los Angeles', 'Chicago', 'Houston', 'Toronto', 'Vancouver', 'Montreal',
      'Mexico City', 'Washington D.C.', 'San Francisco', 'Boston', 'Philadelphia',
      'California', 'Texas', 'Florida', 'Ontario', 'Quebec',
      'Confederate', 'Union Army', 'Colonial America'
    ],
    negativePatterns: []
  },

  europe: {
    keywords: [
      'United Kingdom', 'Britain', 'England', 'Scotland', 'Wales', 'Ireland',
      'France', 'Germany', 'Italy', 'Spain', 'Portugal', 'Netherlands', 'Belgium',
      'Switzerland', 'Austria', 'Poland', 'Czech', 'Hungary', 'Romania', 'Bulgaria',
      'Greece', 'Sweden', 'Norway', 'Denmark', 'Finland', 'Iceland',
      'Russia', 'Ukraine', 'Belarus',
      'British', 'English', 'French', 'German', 'Italian', 'Spanish', 'Dutch',
      'Polish', 'Russian', 'Greek', 'Swedish', 'Norwegian',
      'London', 'Paris', 'Berlin', 'Rome', 'Madrid', 'Barcelona', 'Amsterdam',
      'Vienna', 'Prague', 'Budapest', 'Warsaw', 'Moscow', 'St. Petersburg',
      'Athens', 'Stockholm', 'Copenhagen', 'Dublin', 'Edinburgh', 'Munich',
      'Byzantine', 'Ottoman', 'Habsburg', 'Prussia', 'Austro-Hungarian',
      'Soviet Union', 'USSR', 'Holy Roman Empire', 'Papal States',
      'Czechoslovakia', 'Yugoslavia', 'Constantinople',
      'Eiffel Tower', 'Big Ben', 'Colosseum', 'Kremlin', 'Buckingham Palace'
    ],
    negativePatterns: ['European American']
  },

  asia: {
    keywords: [
      'China', 'Japan', 'India', 'South Korea', 'North Korea', 'Vietnam',
      'Thailand', 'Indonesia', 'Philippines', 'Malaysia', 'Singapore',
      'Pakistan', 'Bangladesh', 'Sri Lanka', 'Nepal', 'Myanmar', 'Cambodia',
      'Taiwan', 'Hong Kong', 'Mongolia', 'Kazakhstan', 'Uzbekistan',
      'Iran', 'Iraq', 'Saudi Arabia', 'Israel', 'Turkey', 'Syria', 'Lebanon',
      'Jordan', 'UAE', 'Qatar', 'Kuwait', 'Afghanistan',
      'Chinese', 'Japanese', 'Indian', 'Korean', 'Vietnamese', 'Thai',
      'Indonesian', 'Filipino', 'Pakistani', 'Iranian', 'Iraqi', 'Israeli',
      'Turkish', 'Saudi', 'Afghan',
      'Tokyo', 'Beijing', 'Shanghai', 'Hong Kong', 'Seoul', 'Mumbai', 'Delhi',
      'Bangkok', 'Singapore', 'Jakarta', 'Manila', 'Taipei', 'Hanoi',
      'Tehran', 'Baghdad', 'Jerusalem', 'Tel Aviv', 'Istanbul', 'Dubai',
      'Karachi', 'Dhaka', 'Kolkata', 'Osaka', 'Kyoto',
      'Persia', 'Persian Empire', 'Siam', 'Burma', 'Ceylon', 'Mesopotamia',
      'Ottoman', 'Mughal', 'Qing Dynasty', 'Ming Dynasty', 'Shogunate',
      'British India', 'French Indochina', 'Manchuria', 'Tibet',
      'Babylonia', 'Assyria', 'Palestine',
      'Great Wall', 'Taj Mahal', 'Forbidden City', 'Mount Fuji'
    ],
    negativePatterns: [
      'Asian American', 'Chinese American', 'Japanese American', 'Korean American',
      'Indian American', 'Vietnamese American', 'Filipino American',
      'Asian Canadian', 'Asian Australian', 'Asian British'
    ]
  },

  africa: {
    keywords: [
      'Egypt', 'Nigeria', 'South Africa', 'Kenya', 'Ethiopia', 'Ghana',
      'Tanzania', 'Morocco', 'Algeria', 'Tunisia', 'Libya', 'Sudan',
      'Uganda', 'Zimbabwe', 'Mozambique', 'Angola', 'Senegal', 'Mali',
      'Ivory Coast', 'Cameroon', 'Congo', 'Rwanda', 'Botswana', 'Namibia',
      'Zambia', 'Malawi', 'Madagascar', 'Mauritius', 'Somalia', 'Eritrea',
      'Cairo', 'Lagos', 'Johannesburg', 'Cape Town', 'Nairobi', 'Accra',
      'Addis Ababa', 'Casablanca', 'Algiers', 'Tunis', 'Khartoum',
      'Dar es Salaam', 'Kinshasa', 'Luanda', 'Harare', 'Maputo',
      'Dakar', 'Abidjan', 'Kampala', 'Pretoria', 'Durban', 'Alexandria',
      'Rhodesia', 'Zaire', 'Abyssinia', 'Gold Coast', 'Belgian Congo',
      'French West Africa', 'British East Africa', 'Tanganyika', 'Nyasaland',
      'Bechuanaland', 'South West Africa', 'Zanzibar', 'Carthage',
      'Ancient Egypt', 'Nubia', 'Kingdom of Kush', 'Mali Empire', 'Songhai',
      'Zulu', 'Ashanti', 'Benin Empire',
      'Sahara', 'Nile', 'Congo River', 'Serengeti', 'Kilimanjaro',
      'Victoria Falls', 'Suez Canal', 'Cape of Good Hope'
    ],
    negativePatterns: [
      'African American', 'African Canadian', 'African British',
      'Afro-American', 'Black American', 'African diaspora in'
    ]
  },

  south_america: {
    keywords: [
      'Brazil', 'Argentina', 'Chile', 'Peru', 'Colombia', 'Venezuela',
      'Ecuador', 'Bolivia', 'Paraguay', 'Uruguay', 'Guyana', 'Suriname',
      'Cuba', 'Puerto Rico', 'Dominican Republic', 'Haiti', 'Jamaica',
      'Panama', 'Costa Rica', 'Guatemala', 'Honduras', 'El Salvador', 'Nicaragua',
      'Brazilian', 'Argentine', 'Argentinian', 'Chilean', 'Peruvian',
      'Colombian', 'Venezuelan', 'Ecuadorian', 'Bolivian', 'Cuban',
      'São Paulo', 'Rio de Janeiro', 'Buenos Aires', 'Lima', 'Bogotá',
      'Santiago', 'Caracas', 'Quito', 'La Paz', 'Montevideo', 'Havana',
      'Brasília', 'Medellín', 'Cartagena', 'Cusco', 'Machu Picchu',
      'Inca', 'Incan Empire', 'Aztec', 'Maya', 'Mayan',
      'Spanish America', 'Portuguese America', 'Gran Colombia',
      'Simón Bolívar', 'Conquistador',
      'Amazon', 'Andes', 'Patagonia', 'Galápagos', 'Tierra del Fuego'
    ],
    negativePatterns: [
      'Latin American community in', 'Latino American', 'Hispanic American',
      'Cuban American', 'Mexican American', 'Puerto Rican in New York',
      'Brazilian American', 'Colombian American'
    ]
  }
}

// Topic classification keywords
const TOPIC_KEYWORDS: Record<Topic, string[]> = {
  sports: ['sport', 'game', 'championship', 'olympic', 'football', 'baseball', 'soccer', 'tennis', 'athlete', 'world cup', 'medal', 'tournament', 'league', 'player', 'coach', 'stadium'],
  history: ['king', 'queen', 'empire', 'ancient', 'medieval', 'treaty', 'declaration', 'revolution', 'dynasty', 'monarch', 'throne', 'kingdom', 'colony', 'independence'],
  politics: ['president', 'election', 'government', 'parliament', 'congress', 'vote', 'law', 'policy', 'minister', 'senator', 'legislation', 'constitution', 'democracy', 'republic'],
  entertainment: ['film', 'movie', 'music', 'actor', 'singer', 'album', 'award', 'show', 'television', 'concert', 'broadway', 'oscar', 'grammy', 'premiere', 'director'],
  science: ['discovery', 'scientist', 'research', 'experiment', 'theory', 'medical', 'disease', 'cure', 'vaccine', 'nobel', 'physics', 'chemistry', 'biology', 'astronomy'],
  technology: ['invention', 'patent', 'computer', 'internet', 'technology', 'space', 'launch', 'satellite', 'nasa', 'rocket', 'spacecraft', 'moon', 'mars', 'aircraft', 'aviation'],
  social_movements: ['rights', 'movement', 'protest', 'equality', 'suffrage', 'civil', 'reform', 'activist', 'march', 'boycott', 'freedom', 'liberation', 'feminist', 'labor union'],
  military: ['war', 'battle', 'army', 'navy', 'military', 'general', 'soldier', 'victory', 'defeat', 'invasion', 'siege', 'treaty', 'armistice', 'admiral', 'air force']
}

// Content that should be filtered out (inappropriate for general audience)
const INAPPROPRIATE_KEYWORDS = [
  'serial killer', 'mass murder', 'genocide', 'massacre', 'torture',
  'rape', 'sexual assault', 'terrorist attack', 'suicide bombing',
  'school shooting', 'execution', 'lynching', 'concentration camp',
  'murder', 'assassin', 'bombing', 'explosion kills', 'death toll',
  'hostage', 'kidnapping', 'child abuse', 'pedophil', 'incest'
]

// Blocklist of specific Wikipedia titles to never include
const TITLE_BLOCKLIST = [
  'List of', 'Deaths in', 'Assassination of', 'Murder of', 'Execution of',
  'Suicide of', 'Killing of', 'Massacre', 'Bombing', 'Attack on',
  'Serial killer', 'Mass shooting', 'School shooting', 'Terrorist',
  'War crimes', 'Genocide', 'Holocaust', 'Famine'
]

// Minimum keyword matches required per region
const MIN_KEYWORD_MATCHES: Record<Region, number> = {
  north_america: 2,
  europe: 2,
  asia: 2,
  africa: 1,
  south_america: 1
}

// Region display labels for Telegram messages
const REGION_EMOJI: Record<Region, string> = {
  north_america: '🌎 North America',
  europe: '🌍 Europe',
  asia: '🌏 Asia',
  africa: '🌍 Africa',
  south_america: '🌎 South America'
}

// -----------------------------------------------------------------------
// Main handler
// -----------------------------------------------------------------------

Deno.serve(async (req) => {
  try {
    // Verify authorization
    const authHeader = req.headers.get('Authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    const url = new URL(req.url)
    const daysParam = parseInt(url.searchParams.get('days') ?? '7', 10)
    const days = isNaN(daysParam) || daysParam < 1 ? 7 : Math.min(daysParam, 30)
    const startDateParam = url.searchParams.get('startDate')

    // Determine start date (default: tomorrow UTC)
    let startDate: Date
    if (startDateParam) {
      startDate = new Date(`${startDateParam}T00:00:00Z`)
      if (isNaN(startDate.getTime())) {
        return new Response(
          JSON.stringify({ error: `Invalid startDate: ${startDateParam}` }),
          { status: 400, headers: { 'Content-Type': 'application/json' } }
        )
      }
    } else {
      startDate = new Date()
      startDate.setUTCDate(startDate.getUTCDate() + 1)
    }

    // Build list of target dates
    const targetDates: string[] = []
    for (let i = 0; i < days; i++) {
      const d = new Date(startDate)
      d.setUTCDate(startDate.getUTCDate() + i)
      targetDates.push(d.toISOString().split('T')[0])
    }

    console.log(`generate-weekly: generating ${days} days starting ${targetDates[0]}`)

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const anthropicApiKey = Deno.env.get('ANTHROPIC_API_KEY')
    if (!anthropicApiKey) {
      return new Response(
        JSON.stringify({ error: 'ANTHROPIC_API_KEY secret not set' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    const telegramToken = Deno.env.get('TELEGRAM_BOT_TOKEN')
    const telegramChatId = Deno.env.get('TELEGRAM_CHAT_ID')

    const summary: Record<string, {
      factsInserted: number
      contextInserted: number
      regions: string[]
      errors: string[]
    }> = {}

    // Process each date
    for (const dateString of targetDates) {
      console.log(`\n===== Processing ${dateString} =====`)
      summary[dateString] = { factsInserted: 0, contextInserted: 0, regions: [], errors: [] }

      const [yearStr, monthStr, dayStr] = dateString.split('-')
      const month = parseInt(monthStr, 10)
      const day = parseInt(dayStr, 10)

      // Generate one fact per region for this date
      const factsForDate: (GeneratedFact & { id?: string })[] = []

      for (const region of REGIONS) {
        try {
          console.log(`  [${region}] Fetching Wikipedia events for ${month}/${day}...`)
          const event = await findBestEventForRegion(region, month, day)

          if (!event) {
            console.log(`  [${region}] No Wikipedia match — trying Claude fallback...`)
            try {
              const fallback = await claudeGenerateFallbackFact(anthropicApiKey, region, month, day, dateString)
              if (fallback) {
                const { error: insertError } = await supabase
                  .from('daily_facts')
                  .upsert(fallback, { onConflict: 'date,region,set_number' })
                if (insertError) {
                  summary[dateString].errors.push(`${region}: fallback DB error - ${insertError.message}`)
                } else {
                  const { data: fallbackRow } = await supabase
                    .from('daily_facts')
                    .select('id')
                    .eq('date', dateString)
                    .eq('region', region)
                    .eq('set_number', 1)
                    .single()
                  const factId = fallbackRow?.id
                  if (factId) {
                    factsForDate.push({ ...fallback, id: factId })
                    summary[dateString].factsInserted++
                    summary[dateString].regions.push(region)
                    console.log(`  [${region}] Claude fallback inserted: ${fallback.title}`)
                    const fallbackYear = extractYear(fallback.title, fallback.full_content)
                    const otherRegions = REGIONS.filter(r => r !== region)
                    for (const contextRegion of otherRegions) {
                      try {
                        const eraLabel = buildEraLabel(fallbackYear)
                        const contextRegionLabel = contextRegion.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())
                        const contextContent = await callClaude(
                          anthropicApiKey,
                          `You are a historian providing historical context.

In about 150 words, describe what was happening in ${contextRegionLabel} during ${eraLabel}, the broader period surrounding ${fallback.title}.

Focus on the political, social, cultural, or economic forces shaping life in that region during that specific time. Mention notable movements, conflicts, technological developments, or cultural changes people living then would have experienced.

Avoid generic regional history and stay anchored to that era. Do not use markdown, rhetorical questions, conversational hooks such as "Honestly," or em dashes.

Before finishing, verify that the response contains no em dashes, no rhetorical questions, and no conversational hooks. If any appear, rewrite the sentence.

Write in clear narrative prose.`
                        )
                        const { error: ctxError } = await supabase
                          .from('world_context')
                          .upsert({ fact_id: factId, context_region: contextRegion, era_label: eraLabel, content: contextContent }, { onConflict: 'fact_id,context_region' })
                        if (!ctxError) summary[dateString].contextInserted++
                      } catch (ctxErr) {
                        console.error(`  [${region} fallback world_context] error for ${contextRegion}:`, ctxErr)
                      }
                    }
                  }
                }
              } else {
                summary[dateString].errors.push(`${region}: no Wikipedia event and Claude fallback failed`)
              }
            } catch (fbErr) {
              summary[dateString].errors.push(`${region}: fallback error - ${String(fbErr)}`)
            }
            continue
          }

          const { page, topic, eventText } = event

          // Fetch article extract for richer content
          const extract = await fetchArticleExtract(page.title)
          const sourceContent = extract || eventText

          // Claude region verification — catches Wikipedia misclassifications
          const regionLabel = REGION_DISPLAY[region]
          const verifyPrompt = `Is this historical event genuinely from or primarily about ${regionLabel}? Answer only YES or NO.\n\nEvent: ${page.title.replace(/_/g, ' ')} — ${eventText}`
          const verdict = await callClaude(anthropicApiKey, verifyPrompt, 'claude-haiku-4-5-20251001', 10)
          if (!verdict.trim().toUpperCase().startsWith('YES')) {
            console.log(`  [${region}] Claude rejected misclassification: ${page.title} — trying fallback`)
            const fallback = await claudeGenerateFallbackFact(anthropicApiKey, region, month, day, dateString)
            if (!fallback) {
              summary[dateString].errors.push(`${region}: misclassified and fallback failed`)
              continue
            }
            // Store fallback instead
            const { error: fbErr } = await supabase
              .from('daily_facts')
              .upsert(fallback, { onConflict: 'date,region,set_number' })
            if (fbErr) { summary[dateString].errors.push(`${region}: fallback DB error - ${fbErr.message}`); continue }
            const { data: fbRow } = await supabase
              .from('daily_facts')
              .select('id')
              .eq('date', dateString)
              .eq('region', region)
              .eq('set_number', 1)
              .single()
            const fbId = fbRow?.id
            if (fbId) {
              factsForDate.push({ ...fallback, id: fbId })
              summary[dateString].factsInserted++
              summary[dateString].regions.push(region)
              const otherRegions = REGIONS.filter(r => r !== region)
              for (const cr of otherRegions) {
                try {
                  const eraLabel = buildEraLabel(extractYear(fallback.title, fallback.full_content))
                  const crLabel = cr.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())
                  const ctxContent = await callClaude(anthropicApiKey, `You are a historian providing historical context.

In about 150 words, describe what was happening in ${crLabel} during ${eraLabel}, the broader period surrounding ${fallback.title}.

Focus on the political, social, cultural, or economic forces shaping life in that region during that specific time. Mention notable movements, conflicts, technological developments, or cultural changes people living then would have experienced.

Avoid generic regional history and stay anchored to that era. Do not use markdown, rhetorical questions, conversational hooks such as "Honestly," or em dashes.

Before finishing, verify that the response contains no em dashes, no rhetorical questions, and no conversational hooks. If any appear, rewrite the sentence.

Write in clear narrative prose.`)
                  await supabase.from('world_context').upsert({ fact_id: fbId, context_region: cr, era_label: eraLabel, content: ctxContent }, { onConflict: 'fact_id,context_region' })
                  summary[dateString].contextInserted++
                } catch { /* continue */ }
              }
            }
            continue
          }

          console.log(`  [${region}] Generating narrative for: ${page.title}`)

          // Generate full narrative with Claude
          // Key: use eventText (the On This Day description) as primary source so
          // Claude writes about the specific EVENT, not the Wikipedia article subject.
          const fullContent = await callClaude(
            anthropicApiKey,
            `You are an engaging historian writing narrative nonfiction for a general audience.

Your response MUST contain exactly 4 paragraphs. Each paragraph MUST be separated by a blank line. This structure is mandatory — do not combine paragraphs or write in a single block.

PARAGRAPH 1 (scene): Begin with the specific date and location. Describe the key action as it unfolds. Use concrete sensory details.
PARAGRAPH 2 (causes): Explain the forces and decisions that led directly to this moment. Be specific — name people, policies, or events.
PARAGRAPH 3 (aftermath): Describe what happened immediately after. Include real reactions, consequences, or changes that followed.
PARAGRAPH 4 (significance): Explain why this moment still matters. Connect it to something that came later.

Rules:
- No em dashes. Replace any with a comma or period.
- No rhetorical questions.
- No conversational openers like "Honestly," "Here's the thing," or "Picture this."
- No markdown, bullets, or headers.
- No general overviews — write only about the specific event below.
- 300 words total across all 4 paragraphs.

The specific event (write about THIS, not the broader subject):
${eventText}

Supporting context (use only details directly relevant to the event):
${sourceContent.slice(0, 400)}`
          )

          // Generate short 2-line summary with Claude
          const summary2line = await callClaude(
            anthropicApiKey,
            `You are an engaging historian writing for a mobile app.

Write exactly 2 sentences summarizing this specific historical event.
Sentence 1 should clearly describe what happened.
Sentence 2 should explain why it mattered.

Use concrete details such as names, places, or outcomes when possible. Avoid vague language, rhetorical questions, conversational hooks such as "Honestly," and avoid em dashes or markdown.

Before finishing, verify that the response contains no em dashes, no rhetorical questions, and no conversational hooks. If any appear, rewrite the sentence.

Event:
${eventText}`
          )

          const fact: GeneratedFact = {
            date: dateString,
            region,
            set_number: 1, // one set per region per day in the new model
            topic,
            title: page.title.replace(/_/g, ' '),
            summary: summary2line,
            full_content: fullContent,
            image_url: page.thumbnail?.source ?? null,
            source_url: page.content_urls?.desktop?.page ?? `https://en.wikipedia.org/wiki/${encodeURIComponent(page.title)}`,
            review_status: 'approved'
          }

          // Upsert fact into daily_facts
          const { error: insertError } = await supabase
            .from('daily_facts')
            .upsert(fact, { onConflict: 'date,region,set_number' })

          if (insertError) {
            console.error(`  [${region}] DB insert error:`, insertError)
            summary[dateString].errors.push(`${region}: DB error - ${insertError.message}`)
            continue
          }

          // Fetch the ID separately — upsert doesn't reliably return it on conflict
          const { data: factRow } = await supabase
            .from('daily_facts')
            .select('id')
            .eq('date', dateString)
            .eq('region', region)
            .eq('set_number', 1)
            .single()

          const factId: string | undefined = factRow?.id
          summary[dateString].factsInserted++
          summary[dateString].regions.push(region)
          factsForDate.push({ ...fact, id: factId })

          // Generate world_context entries for the 4 OTHER regions
          if (factId) {
            const eventYear = extractYear(eventText, page.title)
            const otherRegions = REGIONS.filter(r => r !== region)

            for (const contextRegion of otherRegions) {
              try {
                const eraLabel = buildEraLabel(eventYear)
                const contextRegionLabel = contextRegion.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())

                console.log(`    [world_context] ${region} -> ${contextRegion} (${eraLabel})`)

                const contextContent = await callClaude(
                  anthropicApiKey,
                  `You are a historian providing historical context.

In about 150 words, describe what was happening in ${contextRegionLabel} during ${eraLabel}, the broader period surrounding ${page.title.replace(/_/g, ' ')}.

Focus on the political, social, cultural, or economic forces shaping life in that region during that specific time. Mention notable movements, conflicts, technological developments, or cultural changes people living then would have experienced.

Avoid generic regional history and stay anchored to that era. Do not use markdown, rhetorical questions, conversational hooks such as "Honestly," or em dashes.

Before finishing, verify that the response contains no em dashes, no rhetorical questions, and no conversational hooks. If any appear, rewrite the sentence.

Write in clear narrative prose.`
                )

                const { error: ctxError } = await supabase
                  .from('world_context')
                  .upsert(
                    {
                      fact_id: factId,
                      context_region: contextRegion,
                      era_label: eraLabel,
                      content: contextContent
                    },
                    { onConflict: 'fact_id,context_region' }
                  )

                if (ctxError) {
                  console.error(`    [world_context] insert error:`, ctxError)
                } else {
                  summary[dateString].contextInserted++
                }
              } catch (ctxErr) {
                console.error(`    [world_context] error for ${contextRegion}:`, ctxErr)
              }
            }
          }
        } catch (regionErr) {
          console.error(`  [${region}] Unexpected error:`, regionErr)
          summary[dateString].errors.push(`${region}: ${String(regionErr)}`)
        }
      }

      // Send Telegram message for this date
      if (telegramToken && telegramChatId && factsForDate.length > 0) {
        try {
          await sendTelegramMessage(telegramToken, telegramChatId, dateString, factsForDate)
          console.log(`  Telegram message sent for ${dateString}`)
        } catch (tgErr) {
          console.error(`  Telegram error for ${dateString}:`, tgErr)
          summary[dateString].errors.push(`telegram: ${String(tgErr)}`)
        }
      } else if (!telegramToken || !telegramChatId) {
        console.log(`  Skipping Telegram (secrets not configured)`)
      }
    }

    console.log('\ngenerate-weekly complete.')

    return new Response(
      JSON.stringify({ success: true, daysProcessed: targetDates.length, summary }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )

  } catch (err) {
    console.error('Fatal error:', err)
    return new Response(
      JSON.stringify({ error: String(err) }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})

// -----------------------------------------------------------------------
// Claude API helper
// -----------------------------------------------------------------------

async function callClaude(
  apiKey: string,
  prompt: string,
  model = 'claude-haiku-4-5-20251001',
  maxTokens = 1024
): Promise<string> {
  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json'
    },
    body: JSON.stringify({
      model,
      max_tokens: maxTokens,
      messages: [{ role: 'user', content: prompt }]
    })
  })

  if (!response.ok) {
    const body = await response.text()
    throw new Error(`Claude API error ${response.status}: ${body}`)
  }

  const data = await response.json()
  const text: string = data?.content?.[0]?.text ?? ''
  if (!text) throw new Error('Claude returned empty content')
  return text.trim()
}

// -----------------------------------------------------------------------
// Wikipedia helpers
// -----------------------------------------------------------------------

interface EventCandidate {
  event: WikipediaEvent
  page: WikipediaEvent['pages'][0]
  topic: Topic
  eventText: string
}

async function findBestEventForRegion(
  region: Region,
  month: number,
  day: number
): Promise<EventCandidate | null> {
  const url = `https://en.wikipedia.org/api/rest_v1/feed/onthisday/events/${month}/${day}`

  const response = await fetch(url, {
    headers: { 'User-Agent': 'TodayInHistory/1.0 (contact@example.com)' }
  })

  if (!response.ok) {
    throw new Error(`Wikipedia API error: ${response.status}`)
  }

  const data = await response.json()
  const events: WikipediaEvent[] = data.events || []

  const config = REGION_CONFIG[region]

  const regionEvents = events.filter(event => {
    const title = event.pages[0]?.title || ''
    const pageText = event.pages.map(p => `${p.title} ${p.extract || ''}`).join(' ')
    const combined = `${event.text} ${pageText}`
    const combinedLower = combined.toLowerCase()

    // Title blocklist
    if (TITLE_BLOCKLIST.some(blocked => title.toLowerCase().includes(blocked.toLowerCase()))) {
      return false
    }

    // Negative patterns
    if (config.negativePatterns.some(p => combinedLower.includes(p.toLowerCase()))) {
      return false
    }

    // Inappropriate content
    if (INAPPROPRIATE_KEYWORDS.some(kw => combinedLower.includes(kw.toLowerCase()))) {
      return false
    }

    // Keyword match count
    const matches = config.keywords.filter(kw => combinedLower.includes(kw.toLowerCase())).length
    return matches >= MIN_KEYWORD_MATCHES[region]
  })

  if (regionEvents.length === 0) return null

  // Shuffle and pick first valid one
  const shuffled = shuffleArray(regionEvents)
  for (const event of shuffled) {
    const page = event.pages[0]
    if (!page) continue
    const topic = classifyTopic(event, [])
    if (!topic) continue
    return { event, page, topic, eventText: event.text }
  }

  return null
}

async function fetchArticleExtract(title: string): Promise<string | null> {
  try {
    const url = `https://en.wikipedia.org/api/rest_v1/page/summary/${encodeURIComponent(title)}`
    const response = await fetch(url, {
      headers: { 'User-Agent': 'TodayInHistory/1.0 (contact@example.com)' }
    })
    if (!response.ok) return null
    const data = await response.json()
    return data.extract || null
  } catch {
    return null
  }
}

// -----------------------------------------------------------------------
// Topic classification
// -----------------------------------------------------------------------

function classifyTopic(event: WikipediaEvent, excludeTopics: Topic[]): Topic | null {
  const text = event.text.toLowerCase()
  const pageText = event.pages.map(p => `${p.title} ${p.extract || ''}`).join(' ').toLowerCase()
  const combined = `${text} ${pageText}`

  const scores: Partial<Record<Topic, number>> = {}
  for (const [topic, keywords] of Object.entries(TOPIC_KEYWORDS)) {
    if (excludeTopics.includes(topic as Topic)) continue
    scores[topic as Topic] = keywords.reduce((n, kw) => n + (combined.includes(kw) ? 1 : 0), 0)
  }

  const sorted = (Object.entries(scores) as [Topic, number][]).sort((a, b) => b[1] - a[1])
  const best = sorted[0]
  if (best && best[1] > 0) return best[0]
  return excludeTopics.includes('history') ? null : 'history'
}

// -----------------------------------------------------------------------
// Era label helpers
// -----------------------------------------------------------------------

function extractYear(eventText: string, title: string): number | null {
  // Try to find a 4-digit year in the event text
  const match = eventText.match(/\b(1[0-9]{3}|20[0-2][0-9])\b/)
  if (match) return parseInt(match[1], 10)
  const titleMatch = title.match(/\b(1[0-9]{3}|20[0-2][0-9])\b/)
  if (titleMatch) return parseInt(titleMatch[1], 10)
  return null
}

function buildEraLabel(year: number | null): string {
  if (!year) return 'Modern Era'

  // 5-year window, fall back to decade label
  const decade = Math.floor(year / 10) * 10
  const position = year - decade

  if (position < 3) return `Early ${decade}s`
  if (position < 7) return `Mid-${decade}s`
  return `Late ${decade}s`
}

// -----------------------------------------------------------------------
// Telegram messaging
// -----------------------------------------------------------------------

interface FactWithId extends GeneratedFact {
  id?: string
}

async function sendTelegramMessage(
  token: string,
  chatId: string,
  dateString: string,
  facts: FactWithId[]
): Promise<void> {
  const date = new Date(`${dateString}T00:00:00Z`)
  const dayOfWeek = date.toLocaleDateString('en-US', { weekday: 'long', timeZone: 'UTC' })
  const monthDay = date.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric', timeZone: 'UTC' })

  // ── 1. Send one message per region with full narrative ──────────────────
  for (const region of REGIONS) {
    const fact = facts.find(f => f.region === region)
    if (!fact) continue

    const regenButton = {
      inline_keyboard: [[
        { text: `🔄 Regenerate`, callback_data: `regen_region_${dateString}_${region}` },
        { text: `📝 Note`, callback_data: `note_${dateString}_${region}` }
      ]]
    }

    // Truncate narrative to Telegram's 4096 char limit with buffer for header
    const maxNarrative = 3300
    const narrative = fact.full_content.length > maxNarrative
      ? fact.full_content.slice(0, maxNarrative) + '…'
      : fact.full_content

    const body = [
      `${REGION_EMOJI[region]}  ${fact.title}`,
      `🗓 Goes live: ${dayOfWeek}, ${monthDay}`,
      '',
      narrative
    ].join('\n')

    if (fact.image_url) {
      const res = await fetch(`https://api.telegram.org/bot${token}/sendPhoto`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ chat_id: chatId, photo: fact.image_url, caption: body, reply_markup: regenButton })
      })
      if (!res.ok) {
        // Image failed — fall back to text
        await sendTelegramText(token, chatId, body, regenButton)
      }
    } else {
      await sendTelegramText(token, chatId, body, regenButton)
    }

    // Small delay to avoid Telegram rate limits
    await new Promise(r => setTimeout(r, 300))
  }

  // ── 2. Send summary message with day-level controls ─────────────────────
  const summaryLines = [
    `📋  Summary — ${dayOfWeek}, ${monthDay}`,
    `Auto-approved. Tap Regenerate Day to redo all 5 regions.`,
    ''
  ]
  for (const region of REGIONS) {
    const fact = facts.find(f => f.region === region)
    summaryLines.push(fact
      ? `${REGION_EMOJI[region]}  ${fact.title}`
      : `${REGION_EMOJI[region]}  (not generated)`
    )
  }

  const summaryMarkup = {
    inline_keyboard: [[
      { text: '🔄 Regenerate Day', callback_data: `regen_${dateString}` }
    ]]
  }

  await sendTelegramText(token, chatId, summaryLines.join('\n'), summaryMarkup)
}

async function sendTelegramText(
  token: string,
  chatId: string,
  text: string,
  replyMarkup: unknown
): Promise<void> {
  const response = await fetch(
    `https://api.telegram.org/bot${token}/sendMessage`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chat_id: chatId,
        text,
        reply_markup: replyMarkup
      })
    }
  )
  if (!response.ok) {
    const body = await response.text()
    throw new Error(`Telegram sendMessage error ${response.status}: ${body}`)
  }
}

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

function shuffleArray<T>(array: T[]): T[] {
  const shuffled = [...array]
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]]
  }
  return shuffled
}

// -----------------------------------------------------------------------
// Claude fallback: generates a fact entirely via Claude when Wikipedia
// has no matching event for a region on a given calendar date.
// -----------------------------------------------------------------------

const REGION_DISPLAY: Record<Region, string> = {
  north_america: 'North America',
  europe: 'Europe',
  asia: 'Asia',
  africa: 'Africa',
  south_america: 'South America'
}

const MONTH_NAMES = ['January','February','March','April','May','June','July','August','September','October','November','December']

async function claudeGenerateFallbackFact(
  apiKey: string,
  region: Region,
  month: number,
  day: number,
  dateString: string
): Promise<GeneratedFact | null> {
  const monthName = MONTH_NAMES[month - 1]
  const regionName = REGION_DISPLAY[region]

  // Step 1: ask Claude to pick a real event and return structured JSON
  const pickPrompt = `You are a historian. Identify one real, notable, positive or culturally significant historical event that occurred in ${regionName} on or very close to ${monthName} ${day} in any year. Avoid wars, massacres, assassinations, and tragedies — prefer achievements, discoveries, independence days, cultural milestones, and breakthroughs.

Respond with ONLY valid JSON in this exact format (no markdown, no explanation):
{
  "title": "Short descriptive title of the event",
  "year": 1965,
  "topic": "history",
  "summary": "Two compelling sentences summarising the event for a mobile app card.",
  "narrative": "A vivid, engaging 400-word narrative about the event written for a general audience. Factual and accessible. No markdown.",
  "source_url": "https://en.wikipedia.org/wiki/Relevant_Article_Title"
}`

  const raw = await callClaude(apiKey, pickPrompt, 'claude-haiku-4-5-20251001', 1200)

  let parsed: { title: string; year: number; topic: string; summary: string; narrative: string; source_url: string }
  try {
    // Strip any accidental markdown fences
    const clean = raw.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim()
    parsed = JSON.parse(clean)
  } catch {
    console.error(`  [${region}] Claude fallback JSON parse failed:`, raw.slice(0, 200))
    return null
  }

  const validTopics = ['sports','history','politics','entertainment','science','technology','social_movements','military']
  const topic = validTopics.includes(parsed.topic) ? parsed.topic as Topic : 'history'

  return {
    date: dateString,
    region,
    set_number: 1,
    topic,
    title: parsed.title,
    summary: parsed.summary,
    full_content: parsed.narrative,
    image_url: null,  // no Wikipedia image for Claude-generated facts
    source_url: parsed.source_url || `https://en.wikipedia.org/wiki/${encodeURIComponent(parsed.title)}`,
    review_status: 'approved'
  }
}

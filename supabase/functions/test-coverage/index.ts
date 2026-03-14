// Test script to check region coverage across multiple dates
// Run this to identify if keyword thresholds are too strict

const REGIONS = ['north_america', 'europe', 'asia', 'africa', 'south_america'] as const
type Region = typeof REGIONS[number]

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

const MIN_KEYWORD_MATCHES: Record<Region, number> = {
  north_america: 2,
  europe: 2,
  asia: 2,
  africa: 1,
  south_america: 2
}

interface WikipediaEvent {
  year: number
  text: string
  pages: Array<{
    title: string
    extract?: string
  }>
}

async function testDate(month: number, day: number): Promise<Record<Region, number>> {
  const url = `https://en.wikipedia.org/api/rest_v1/feed/onthisday/events/${month}/${day}`

  const response = await fetch(url, {
    headers: { 'User-Agent': 'TodayInHistory/1.0 (test)' }
  })

  if (!response.ok) {
    throw new Error(`Wikipedia API error: ${response.status}`)
  }

  const data = await response.json()
  const events: WikipediaEvent[] = data.events || []

  const counts: Record<Region, number> = {
    north_america: 0,
    europe: 0,
    asia: 0,
    africa: 0,
    south_america: 0
  }

  for (const region of REGIONS) {
    const config = REGION_CONFIG[region]

    const regionEvents = events.filter(event => {
      const text = event.text
      const pageText = event.pages.map(p => `${p.title} ${p.extract || ''}`).join(' ')
      const combined = `${text} ${pageText}`
      const combinedLower = combined.toLowerCase()

      // Check negative patterns
      const hasNegativePattern = config.negativePatterns.some(pattern =>
        combinedLower.includes(pattern.toLowerCase())
      )
      if (hasNegativePattern) return false

      // Count keyword matches
      const keywordMatches = config.keywords.filter(kw =>
        combinedLower.includes(kw.toLowerCase())
      ).length

      return keywordMatches >= MIN_KEYWORD_MATCHES[region]
    })

    counts[region] = regionEvents.length
  }

  return counts
}

Deno.serve(async (req) => {
  try {
    const results: Array<{
      date: string
      counts: Record<Region, number>
    }> = []

    // Test 10 random dates across the year
    const testDates = [
      { month: 1, day: 15 },
      { month: 2, day: 23 },
      { month: 3, day: 8 },
      { month: 4, day: 22 },
      { month: 5, day: 10 },
      { month: 6, day: 5 },
      { month: 7, day: 4 },
      { month: 8, day: 15 },
      { month: 9, day: 21 },
      { month: 10, day: 12 },
      { month: 11, day: 11 },
      { month: 12, day: 25 }
    ]

    for (const { month, day } of testDates) {
      const counts = await testDate(month, day)
      results.push({
        date: `${month}/${day}`,
        counts
      })
      // Small delay to be nice to Wikipedia API
      await new Promise(r => setTimeout(r, 200))
    }

    // Calculate averages
    const averages: Record<Region, number> = {
      north_america: 0,
      europe: 0,
      asia: 0,
      africa: 0,
      south_america: 0
    }

    for (const region of REGIONS) {
      const sum = results.reduce((acc, r) => acc + r.counts[region], 0)
      averages[region] = Math.round(sum / results.length * 10) / 10
    }

    // Find dates with zero coverage
    const zeroCountDates: Record<Region, string[]> = {
      north_america: [],
      europe: [],
      asia: [],
      africa: [],
      south_america: []
    }

    for (const result of results) {
      for (const region of REGIONS) {
        if (result.counts[region] === 0) {
          zeroCountDates[region].push(result.date)
        }
      }
    }

    return new Response(JSON.stringify({
      summary: {
        datesChecked: results.length,
        averageMatchesPerRegion: averages,
        datesWithZeroMatches: zeroCountDates
      },
      details: results
    }, null, 2))

  } catch (error) {
    return new Response(JSON.stringify({ error: String(error) }), { status: 500 })
  }
})

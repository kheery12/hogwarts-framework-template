// Today In History - Telegram Webhook Edge Function
// Handles button callbacks from Telegram (Approve Day / Regenerate)
// and the /approve_all admin command.
//
// Register this webhook URL with Telegram once after deploying:
//   curl "https://api.telegram.org/bot<TOKEN>/setWebhook?url=<FUNCTION_URL>"
//
// Secrets required:
//   TELEGRAM_BOT_TOKEN
//   SUPABASE_URL
//   SUPABASE_SERVICE_ROLE_KEY

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// -----------------------------------------------------------------------
// Telegram Update type (minimal - only fields we use)
// -----------------------------------------------------------------------

interface TelegramUpdate {
  update_id: number
  callback_query?: {
    id: string
    from: { id: number; first_name: string }
    message?: { chat: { id: number } }
    data?: string
  }
  message?: {
    message_id: number
    chat: { id: number }
    text?: string
    from?: { id: number; first_name: string }
  }
}

// -----------------------------------------------------------------------
// Main handler
// -----------------------------------------------------------------------

Deno.serve(async (req) => {
  // Telegram sends POST requests for all updates
  if (req.method !== 'POST') {
    return new Response('OK', { status: 200 })
  }

  let update: TelegramUpdate
  try {
    update = await req.json()
  } catch {
    // Malformed body - return 200 so Telegram doesn't keep retrying
    console.error('Failed to parse Telegram update body')
    return new Response('OK', { status: 200 })
  }

  console.log('Telegram update received:', JSON.stringify(update).slice(0, 500))

  const token = Deno.env.get('TELEGRAM_BOT_TOKEN')!
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  try {
    // ------------------------------------------------------------------
    // Handle inline keyboard callbacks (Approve / Regenerate buttons)
    // ------------------------------------------------------------------
    if (update.callback_query) {
      const cbq = update.callback_query
      const data = cbq.data ?? ''

      if (data.startsWith('regen_region_')) {
        // Regenerate a single region: regen_region_YYYY-MM-DD_region_name
        const parts = data.slice('regen_region_'.length).split('_')
        const dateString = parts[0]
        const region = parts.slice(1).join('_')
        console.log(`Regenerating ${region} for date: ${dateString}`)

        await answerCallbackQuery(token, cbq.id, `🔄 Regenerating ${region} for ${dateString}...`)

        const generateUrl = `${Deno.env.get('SUPABASE_URL')}/functions/v1/generate-facts?days=1&startDate=${dateString}&region=${region}`
        const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
        fetch(generateUrl, {
          method: 'POST',
          headers: { 'Authorization': `Bearer ${serviceKey}`, 'Content-Type': 'application/json' }
        }).catch((err) => console.error(`regen_region call failed:`, err))

      } else if (data.startsWith('regen_')) {
        const dateString = data.slice('regen_'.length)
        console.log(`Regenerating all facts for date: ${dateString}`)

        await answerCallbackQuery(token, cbq.id, `🔄 Regenerating all facts for ${dateString}...`)

        const generateUrl = `${Deno.env.get('SUPABASE_URL')}/functions/v1/generate-facts?days=1&startDate=${dateString}`
        const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
        fetch(generateUrl, {
          method: 'POST',
          headers: { 'Authorization': `Bearer ${serviceKey}`, 'Content-Type': 'application/json' }
        }).catch((err) => console.error(`regen call failed:`, err))

      } else if (data.startsWith('note_')) {
        // note_YYYY-MM-DD_region — prompt user to type their note
        const parts = data.slice('note_'.length).split('_')
        const dateString = parts[0]
        const region = parts.slice(1).join('_').replace(/_/g, ' ')
        await answerCallbackQuery(token, cbq.id, `Type your note now — just send a message to this chat.`)
        const chatId = cbq.message?.chat.id
        if (chatId) {
          await sendMessage(token, chatId, `📝 Note for ${region} on ${dateString}:\nJust type your feedback as a reply and I'll log it.`)
        }

      } else {
        // Unknown callback data - just dismiss the spinner
        await answerCallbackQuery(token, cbq.id, '')
      }
    }

    // ------------------------------------------------------------------
    // Handle text commands
    // ------------------------------------------------------------------
    else if (update.message?.text) {
      const text = update.message.text.trim()
      const chatId = update.message.chat.id

      if (text === '/approve_all') {
        console.log('/approve_all command received')

        const { data: updated, error } = await supabase
          .from('daily_facts')
          .update({ review_status: 'approved' })
          .eq('review_status', 'pending')
          .select('date')

        if (error) {
          console.error('Supabase approve_all error:', error)
          await sendMessage(token, chatId, `Error approving all facts: ${error.message}`)
        } else {
          const dates = [...new Set((updated ?? []).map((r: { date: string }) => r.date))].sort()
          const count = updated?.length ?? 0
          if (count === 0) {
            await sendMessage(token, chatId, 'No pending facts to approve.')
          } else {
            await sendMessage(
              token,
              chatId,
              `✅ Approved ${count} fact(s) across ${dates.length} date(s):\n${dates.join(', ')}`
            )
          }
        }
      }

      } else if (text.startsWith('/preview')) {
        // /preview YYYY-MM-DD region
        // e.g. /preview 2026-03-15 north_america
        const parts = text.split(' ')
        const dateArg = parts[1]
        const regionArg = parts[2]
        const chatId = update.message!.chat.id

        if (!dateArg || !regionArg) {
          await sendMessage(token, chatId,
            'Usage: /preview YYYY-MM-DD region\n\nRegions: north_america, europe, asia, africa, south_america\n\nExample:\n/preview 2026-03-15 europe'
          )
        } else {
          // Fetch the main fact for this region + date
          const { data: facts, error: factErr } = await supabase
            .from('daily_facts')
            .select('*')
            .eq('date', dateArg)
            .eq('region', regionArg)
            .limit(1)

          if (factErr || !facts || facts.length === 0) {
            await sendMessage(token, chatId, `No fact found for ${regionArg} on ${dateArg}.`)
          } else {
            const fact = facts[0]

            // Fetch world context for this fact
            const { data: contexts } = await supabase
              .from('world_context')
              .select('*')
              .eq('fact_id', fact.id)
              .order('context_region')

            const regionEmoji: Record<string, string> = {
              north_america: '🌎 North America',
              europe: '🌍 Europe',
              asia: '🌏 Asia',
              africa: '🌍 Africa',
              south_america: '🌎 South America'
            }

            const previewLines = [
              `👤 USER PREVIEW — ${regionEmoji[regionArg] ?? regionArg}`,
              `📅 ${dateArg}`,
              ``,
              `━━━ MAIN EVENT ━━━`,
              `${fact.title}`,
              ``,
              fact.summary,
              ``,
              `━━━ FULL READ ━━━`,
              fact.full_content.slice(0, 1200) + (fact.full_content.length > 1200 ? '…' : ''),
              ``
            ]

            if (contexts && contexts.length > 0) {
              previewLines.push(`━━━ AROUND THE WORLD ━━━`)
              for (const ctx of contexts) {
                previewLines.push(``)
                previewLines.push(`${regionEmoji[ctx.context_region] ?? ctx.context_region} — ${ctx.era_label}`)
                previewLines.push(ctx.content.slice(0, 300) + (ctx.content.length > 300 ? '…' : ''))
              }
            }

            const preview = previewLines.join('\n')
            // Send in chunks if too long
            const chunkSize = 4000
            for (let i = 0; i < preview.length; i += chunkSize) {
              await sendMessage(token, chatId, preview.slice(i, i + chunkSize))
              if (i + chunkSize < preview.length) {
                await new Promise(r => setTimeout(r, 300))
              }
            }
          }
        }

      // Add more commands here as needed
      }
    }
  } catch (err) {
    // Log but always return 200 - Telegram requires it
    console.error('Error processing update:', err)
  }

  // Telegram requires a 200 response for all updates
  return new Response('OK', { status: 200 })
})

// -----------------------------------------------------------------------
// Telegram API helpers
// -----------------------------------------------------------------------

async function answerCallbackQuery(
  token: string,
  callbackQueryId: string,
  text: string
): Promise<void> {
  try {
    const response = await fetch(
      `https://api.telegram.org/bot${token}/answerCallbackQuery`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          callback_query_id: callbackQueryId,
          text,
          show_alert: false
        })
      }
    )
    if (!response.ok) {
      console.error(`answerCallbackQuery error: ${response.status}`)
    }
  } catch (err) {
    console.error('answerCallbackQuery failed:', err)
  }
}

async function sendMessage(
  token: string,
  chatId: number,
  text: string
): Promise<void> {
  try {
    const response = await fetch(
      `https://api.telegram.org/bot${token}/sendMessage`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ chat_id: chatId, text })
      }
    )
    if (!response.ok) {
      console.error(`sendMessage error: ${response.status}`)
    }
  } catch (err) {
    console.error('sendMessage failed:', err)
  }
}

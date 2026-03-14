#!/bin/bash

# Today In History - Supabase Edge Functions Deployment Script
# Run this after installing Supabase CLI: npm install -g supabase

set -e

echo "Deploying Edge Functions to Supabase..."
echo ""

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "ERROR: Supabase CLI not found. Install with:"
    echo "   npm install -g supabase"
    exit 1
fi

# Check if logged in
if ! supabase projects list &> /dev/null; then
    echo "Please login to Supabase:"
    supabase login
fi

# Link project if not already linked
if [ ! -f ".supabase/config.toml" ]; then
    echo "Linking to project ewjpdmuloojbxypqscqp..."
    supabase link --project-ref ewjpdmuloojbxypqscqp
fi

# ---------------------------------------------------------------------------
# Deploy functions
# ---------------------------------------------------------------------------

echo ""
echo "Deploying generate-facts function (weekly generation logic)..."
supabase functions deploy generate-facts

echo ""
echo "Deploying telegram-webhook function..."
supabase functions deploy telegram-webhook

echo ""
echo "Deployment complete!"

# ---------------------------------------------------------------------------
# Post-deployment steps
# ---------------------------------------------------------------------------

echo ""
echo "========================================================"
echo "POST-DEPLOYMENT STEPS"
echo "========================================================"
echo ""
echo "1. Set required secrets (if not already set):"
echo ""
echo "   supabase secrets set ANTHROPIC_API_KEY=<your-key>"
echo "   supabase secrets set TELEGRAM_BOT_TOKEN=<your-token>"
echo "   supabase secrets set TELEGRAM_CHAT_ID=<your-chat-id>"
echo ""
echo "2. Register the Telegram webhook (run once after deploying):"
echo ""
echo "   FUNCTION_URL=\"https://ewjpdmuloojbxypqscqp.supabase.co/functions/v1/telegram-webhook\""
echo "   TELEGRAM_TOKEN=\"<your-telegram-bot-token>\""
echo ""
echo "   curl \"https://api.telegram.org/bot\${TELEGRAM_TOKEN}/setWebhook?url=\${FUNCTION_URL}\""
echo ""
echo "   Verify webhook registration:"
echo "   curl \"https://api.telegram.org/bot\${TELEGRAM_TOKEN}/getWebhookInfo\""
echo ""
echo "3. Run the migration in Supabase SQL Editor:"
echo "   supabase/migrations/20260313_redesign.sql"
echo ""
echo "4. Set up pg_cron in Supabase Dashboard > Database > Extensions,"
echo "   then run the following SQL to schedule weekly generation:"
echo ""
echo "   -- Runs every Sunday at 06:00 UTC"
echo "   SELECT cron.schedule("
echo "     'generate-weekly-facts',"
echo "     '0 6 * * 0',"
echo "     \$\$SELECT net.http_post("
echo "       url := 'https://ewjpdmuloojbxypqscqp.supabase.co/functions/v1/generate-facts',"
echo "       headers := '{\"Authorization\": \"Bearer YOUR_SERVICE_ROLE_KEY\", \"Content-Type\": \"application/json\"}'::jsonb,"
echo "       body := '{}'::jsonb"
echo "     )\$\$"
echo "   );"
echo ""
echo "5. Test generate-facts manually:"
echo "   curl -X POST 'https://ewjpdmuloojbxypqscqp.supabase.co/functions/v1/generate-facts' \\"
echo "     -H 'Authorization: Bearer YOUR_SERVICE_ROLE_KEY'"
echo ""
echo "   To generate a specific date:"
echo "   curl -X POST 'https://ewjpdmuloojbxypqscqp.supabase.co/functions/v1/generate-facts?days=1&startDate=2026-03-15' \\"
echo "     -H 'Authorization: Bearer YOUR_SERVICE_ROLE_KEY'"
echo ""

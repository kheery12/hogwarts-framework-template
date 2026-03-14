-- Today In History - Schema Redesign Migration
-- 2026-03-13
-- Changes:
--   - Simplify users table (remove pro/regeneration columns, add area_of_interest)
--   - Add review_status to daily_facts for Telegram moderation workflow
--   - Drop user_preferences (all features now free)
--   - Add world_context table for regional context per fact
--   - Drop legacy cron functions no longer needed

-- ================================================
-- ALTER TABLE users
-- ================================================

ALTER TABLE users
    DROP COLUMN IF EXISTS is_pro,
    DROP COLUMN IF EXISTS regenerations_today,
    DROP COLUMN IF EXISTS last_regeneration_date;

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS area_of_interest TEXT
        CHECK (area_of_interest IN (
            'north_america', 'europe', 'asia', 'africa', 'south_america'
        ));
-- NULL means user has not completed onboarding yet

-- ================================================
-- ALTER TABLE daily_facts
-- ================================================

ALTER TABLE daily_facts
    ADD COLUMN IF NOT EXISTS review_status TEXT NOT NULL DEFAULT 'pending'
        CHECK (review_status IN ('pending', 'approved', 'rejected'));

-- Index for efficient querying by date + review_status
CREATE INDEX IF NOT EXISTS idx_daily_facts_date_review_status
    ON daily_facts(date, review_status);

-- ================================================
-- DROP user_preferences
-- (no longer needed - all features are free)
-- ================================================

DROP TABLE IF EXISTS user_preferences;

-- ================================================
-- CREATE world_context
-- ================================================

CREATE TABLE IF NOT EXISTS world_context (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fact_id         UUID NOT NULL REFERENCES daily_facts(id) ON DELETE CASCADE,
    context_region  TEXT NOT NULL CHECK (context_region IN (
                        'north_america', 'europe', 'asia', 'africa', 'south_america'
                    )),
    era_label       TEXT NOT NULL,   -- e.g. "Mid-1960s", "Early 1990s"
    content         TEXT NOT NULL,   -- ~150 word contextual narrative
    created_at      TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE (fact_id, context_region)
);

CREATE INDEX IF NOT EXISTS idx_world_context_fact
    ON world_context(fact_id);

-- RLS for world_context
ALTER TABLE world_context ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read world context"
    ON world_context FOR SELECT
    USING (true);

CREATE POLICY "Service role can manage world context"
    ON world_context FOR ALL
    USING (auth.role() = 'service_role');

-- ================================================
-- DROP legacy functions
-- ================================================

DROP FUNCTION IF EXISTS reset_daily_regenerations();
DROP FUNCTION IF EXISTS cleanup_old_fact_views();

-- ================================================
-- CRON JOBS (requires pg_cron extension)
-- ================================================

-- Note: Run these AFTER enabling pg_cron in Supabase dashboard

-- Generate weekly facts every Sunday at 06:00 UTC
-- SELECT cron.schedule(
--     'generate-weekly-facts',
--     '0 6 * * 0',
--     $$SELECT net.http_post(
--         url := 'https://YOUR_PROJECT_ID.supabase.co/functions/v1/generate-facts',
--         headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY", "Content-Type": "application/json"}'::jsonb,
--         body := '{}'::jsonb
--     )$$
-- );

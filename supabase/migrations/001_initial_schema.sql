-- Today In History - Initial Database Schema
-- Run this in your Supabase SQL Editor

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================
-- TABLES
-- ================================================

-- Users table (extends Supabase auth.users)
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
    display_name TEXT,
    is_pro BOOLEAN DEFAULT FALSE,
    regenerations_today INTEGER DEFAULT 0,
    last_regeneration_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User preferences (Pro feature - topic selection)
CREATE TABLE user_preferences (
    user_id UUID REFERENCES users ON DELETE CASCADE,
    topic TEXT CHECK (topic IN (
        'sports', 'history', 'politics', 'entertainment',
        'science', 'technology', 'social_movements', 'military'
    )),
    enabled BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (user_id, topic)
);

-- Daily facts (generated server-side by Edge Function)
CREATE TABLE daily_facts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    date DATE NOT NULL,
    region TEXT NOT NULL CHECK (region IN (
        'north_america', 'europe', 'asia', 'africa', 'south_america'
    )),
    set_number INTEGER NOT NULL CHECK (set_number BETWEEN 1 AND 3),
    topic TEXT NOT NULL,
    title TEXT NOT NULL,
    summary TEXT NOT NULL,           -- 2-3 sentences
    full_content TEXT NOT NULL,      -- 400-600 words
    image_url TEXT,
    source_url TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE (date, region, set_number)
);

-- User favorites
CREATE TABLE favorites (
    user_id UUID REFERENCES users ON DELETE CASCADE,
    fact_id UUID REFERENCES daily_facts ON DELETE CASCADE,
    saved_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, fact_id)
);

-- User fact views (track which sets they've seen today)
CREATE TABLE user_fact_views (
    user_id UUID REFERENCES users ON DELETE CASCADE,
    fact_id UUID REFERENCES daily_facts ON DELETE CASCADE,
    viewed_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, fact_id)
);

-- ================================================
-- INDEXES
-- ================================================

CREATE INDEX idx_daily_facts_date ON daily_facts(date);
CREATE INDEX idx_daily_facts_date_region ON daily_facts(date, region);
CREATE INDEX idx_daily_facts_date_region_set ON daily_facts(date, region, set_number);
CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_favorites_user_saved ON favorites(user_id, saved_at DESC);
CREATE INDEX idx_user_fact_views_user ON user_fact_views(user_id);

-- ================================================
-- ROW LEVEL SECURITY
-- ================================================

-- Users: read/update own data only
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
    ON users FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
    ON users FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own data"
    ON users FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Daily facts: public read (anyone can view facts)
ALTER TABLE daily_facts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read daily facts"
    ON daily_facts FOR SELECT
    USING (true);

-- Service role only can insert/update facts (Edge Function)
CREATE POLICY "Service role can manage facts"
    ON daily_facts FOR ALL
    USING (auth.role() = 'service_role');

-- Favorites: users manage their own
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own favorites"
    ON favorites FOR ALL
    USING (auth.uid() = user_id);

-- Preferences: users manage their own
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own preferences"
    ON user_preferences FOR ALL
    USING (auth.uid() = user_id);

-- User fact views: users manage their own
ALTER TABLE user_fact_views ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own fact views"
    ON user_fact_views FOR ALL
    USING (auth.uid() = user_id);

-- ================================================
-- FUNCTIONS
-- ================================================

-- Function to reset daily regeneration counts (called by cron)
CREATE OR REPLACE FUNCTION reset_daily_regenerations()
RETURNS void AS $$
BEGIN
    UPDATE users
    SET regenerations_today = 0
    WHERE last_regeneration_date < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to clean up old fact views (keep 7 days)
CREATE OR REPLACE FUNCTION cleanup_old_fact_views()
RETURNS void AS $$
BEGIN
    DELETE FROM user_fact_views
    WHERE viewed_at < NOW() - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================
-- CRON JOBS (requires pg_cron extension)
-- ================================================

-- Note: Run these AFTER enabling pg_cron in Supabase dashboard

-- Reset regeneration counts at midnight UTC
-- SELECT cron.schedule(
--     'reset-regenerations',
--     '0 0 * * *',
--     $$SELECT reset_daily_regenerations()$$
-- );

-- Generate daily facts at midnight UTC
-- SELECT cron.schedule(
--     'generate-daily-facts',
--     '0 0 * * *',
--     $$SELECT net.http_post(
--         url := 'https://YOUR_PROJECT_ID.supabase.co/functions/v1/generate-facts',
--         headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
--     )$$
-- );

-- Cleanup old fact views weekly
-- SELECT cron.schedule(
--     'cleanup-fact-views',
--     '0 3 * * 0',
--     $$SELECT cleanup_old_fact_views()$$
-- );

-- ================================================
-- SEED DATA (Optional - for testing)
-- ================================================

-- Uncomment to insert test facts:
/*
INSERT INTO daily_facts (date, region, set_number, topic, title, summary, full_content, source_url)
VALUES
    (CURRENT_DATE, 'north_america', 1, 'history', 'Test Fact NA 1',
     'This is a test summary for North America.', 'Full content here...', 'https://en.wikipedia.org/wiki/Test'),
    (CURRENT_DATE, 'europe', 1, 'science', 'Test Fact EU 1',
     'This is a test summary for Europe.', 'Full content here...', 'https://en.wikipedia.org/wiki/Test'),
    (CURRENT_DATE, 'asia', 1, 'technology', 'Test Fact AS 1',
     'This is a test summary for Asia.', 'Full content here...', 'https://en.wikipedia.org/wiki/Test'),
    (CURRENT_DATE, 'africa', 1, 'history', 'Test Fact AF 1',
     'This is a test summary for Africa.', 'Full content here...', 'https://en.wikipedia.org/wiki/Test'),
    (CURRENT_DATE, 'south_america', 1, 'politics', 'Test Fact SA 1',
     'This is a test summary for South America.', 'Full content here...', 'https://en.wikipedia.org/wiki/Test');
*/

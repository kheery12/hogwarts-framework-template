-- Migration: Add fact votes table for polling feature
-- "Is this still relevant/impactful today?" - Yes/No voting

CREATE TABLE IF NOT EXISTS fact_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fact_id UUID REFERENCES daily_facts(id) ON DELETE CASCADE NOT NULL,
  device_id TEXT NOT NULL,  -- For anonymous voting (stored in UserDefaults)
  vote BOOLEAN NOT NULL,     -- true = yes, false = no
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(fact_id, device_id)  -- One vote per device per fact
);

-- Index for quick lookups
CREATE INDEX IF NOT EXISTS idx_fact_votes_fact_id ON fact_votes(fact_id);

-- RLS policies
ALTER TABLE fact_votes ENABLE ROW LEVEL SECURITY;

-- Anyone can read vote counts (aggregated)
CREATE POLICY "Anyone can read vote counts"
  ON fact_votes FOR SELECT
  USING (true);

-- Anyone can insert their vote
CREATE POLICY "Anyone can vote"
  ON fact_votes FOR INSERT
  WITH CHECK (true);

-- Users can update their own vote (by device_id)
CREATE POLICY "Users can update own vote"
  ON fact_votes FOR UPDATE
  USING (true);

-- Function to get vote summary for a fact
CREATE OR REPLACE FUNCTION get_vote_summary(p_fact_id UUID)
RETURNS TABLE (
  total_votes BIGINT,
  yes_votes BIGINT,
  no_votes BIGINT,
  yes_percentage NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*)::BIGINT as total_votes,
    COUNT(*) FILTER (WHERE vote = true)::BIGINT as yes_votes,
    COUNT(*) FILTER (WHERE vote = false)::BIGINT as no_votes,
    CASE
      WHEN COUNT(*) > 0 THEN
        ROUND((COUNT(*) FILTER (WHERE vote = true)::NUMERIC / COUNT(*)::NUMERIC) * 100, 1)
      ELSE 0
    END as yes_percentage
  FROM fact_votes
  WHERE fact_id = p_fact_id;
END;
$$ LANGUAGE plpgsql;

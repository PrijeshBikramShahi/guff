-- Fix online status: Set last_seen to NULL for existing users
-- This prevents everyone from showing as online
-- Run this SQL in your Supabase SQL Editor

-- Option 1: Set all existing users' last_seen to NULL (they'll show as offline until they use the app)
UPDATE public.users
SET last_seen = NULL
WHERE last_seen IS NOT NULL;

-- Option 2: Or set last_seen to a date in the past (e.g., 1 day ago)
-- Uncomment the line below if you prefer this approach:
-- UPDATE public.users
-- SET last_seen = NOW() - INTERVAL '1 day'
-- WHERE last_seen IS NOT NULL;

-- Note: After running this, users will only show as "Online" if they:
-- 1. Have the app open
-- 2. Have been active within the last 2 minutes (based on the app's update frequency)


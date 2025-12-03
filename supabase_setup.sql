-- Step 2: Create messages table and setup for real-time chat
-- Run this SQL in your Supabase SQL Editor

-- 1. Create messages table
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  text TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  user_avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- 3. Create RLS policies
-- Allow authenticated users to read all messages
CREATE POLICY "Allow authenticated users to read messages" 
ON messages
FOR SELECT 
USING (auth.role() = 'authenticated');

-- Allow authenticated users to insert their own messages
CREATE POLICY "Allow authenticated users to insert messages" 
ON messages
FOR INSERT 
WITH CHECK (
  auth.role() = 'authenticated' 
  AND auth.uid() = user_id
);

-- 4. Enable real-time replication for messages table
-- This allows real-time updates via WebSocket
-- Note: If this fails, the table might already be in the publication
DO $$
BEGIN
  -- Add table to realtime publication if not already there
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
    AND tablename = 'messages'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE messages;
  END IF;
END $$;

-- 5. Create an index for faster queries (optional but recommended)
CREATE INDEX IF NOT EXISTS messages_created_at_idx ON messages(created_at DESC);

-- For testing without auth (temporary - remove later):
-- Allow public read/write for development
-- DROP POLICY IF EXISTS "Allow public read" ON messages;
-- DROP POLICY IF EXISTS "Allow public insert" ON messages;
-- 
-- CREATE POLICY "Allow public read" ON messages
--   FOR SELECT USING (true);
-- 
-- CREATE POLICY "Allow public insert" ON messages
--   FOR INSERT WITH CHECK (true);


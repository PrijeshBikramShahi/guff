-- TEMPORARY: Allow public access for testing (Steps 4-7)
-- This allows the hardcoded user to send/receive messages
-- REMOVE THIS in Step 12 when we add real authentication!

-- Step 1: Remove foreign key constraint (allows any user_id)
ALTER TABLE messages 
DROP CONSTRAINT IF EXISTS messages_user_id_fkey;

-- Step 2: Drop existing policies
DROP POLICY IF EXISTS "Allow authenticated users to read messages" ON messages;
DROP POLICY IF EXISTS "Allow authenticated users to insert messages" ON messages;
DROP POLICY IF EXISTS "Allow public read" ON messages;
DROP POLICY IF EXISTS "Allow public insert" ON messages;

-- Step 3: Create temporary public policies for development
CREATE POLICY "Allow public read" ON messages
  FOR SELECT USING (true);

CREATE POLICY "Allow public insert" ON messages
  FOR INSERT WITH CHECK (true);

-- Note: In Step 12, we'll restore:
-- 1. The foreign key constraint to auth.users
-- 2. The authenticated-only policies


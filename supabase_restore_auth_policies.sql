-- Restore proper authentication policies (run after Step 12)
-- This replaces the temporary public access with authenticated-only access

-- Step 1: Restore foreign key constraint to auth.users
ALTER TABLE messages 
ADD CONSTRAINT messages_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Step 2: Drop temporary public policies
DROP POLICY IF EXISTS "Allow public read" ON messages;
DROP POLICY IF EXISTS "Allow public insert" ON messages;

-- Step 3: Create authenticated-only policies
CREATE POLICY "Allow authenticated users to read messages" 
ON messages
FOR SELECT 
USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to insert messages" 
ON messages
FOR INSERT 
WITH CHECK (
  auth.role() = 'authenticated' 
  AND auth.uid() = user_id
);

-- Now only authenticated users can read/write messages
-- And they can only insert messages with their own user_id


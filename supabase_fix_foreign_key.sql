-- Fix foreign key constraint for testing (Steps 4-7)
-- The messages table has a foreign key to auth.users, but our test user doesn't exist
-- This temporarily removes the constraint for testing

-- Drop the foreign key constraint temporarily
ALTER TABLE messages 
DROP CONSTRAINT IF EXISTS messages_user_id_fkey;

-- Note: In Step 12, when we add real authentication, we'll restore this constraint
-- For now, this allows us to test with the hardcoded user ID


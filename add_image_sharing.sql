-- Add image/file sharing functionality to direct messages
-- Run this SQL in your Supabase SQL Editor

-- 1. Add message_type column to direct_messages table
ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'file'));

-- 2. Add file_url column to direct_messages table
ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS file_url TEXT;

-- 3. Add file_name column (optional, for file messages)
ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS file_name TEXT;

-- 4. Add file_size column (optional, for file messages)
ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS file_size BIGINT;

-- 5. Create index for faster queries
CREATE INDEX IF NOT EXISTS direct_messages_type_idx ON public.direct_messages(message_type);

-- Note: You'll also need to set up Supabase Storage:
-- 1. Go to Storage in Supabase Dashboard
-- 2. Create a bucket named "chat-files" (or any name you prefer)
-- 3. Set it to Public (or configure RLS policies)
-- 4. The bucket will store uploaded images/files


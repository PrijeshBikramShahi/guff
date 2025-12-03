-- Step 1: Create tables for Direct Messaging (DMs)
-- Run this SQL in your Supabase SQL Editor

-- 1. Create conversations table (for DM chat rooms)
CREATE TABLE IF NOT EXISTS public.conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user1_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user2_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  -- Ensure user1_id < user2_id to prevent duplicate conversations
  CONSTRAINT check_user_order CHECK (user1_id < user2_id),
  -- Ensure users can't have a conversation with themselves
  CONSTRAINT check_different_users CHECK (user1_id != user2_id),
  -- Ensure unique conversation between two users
  UNIQUE(user1_id, user2_id)
);

-- 2. Create direct_messages table (messages in conversations)
CREATE TABLE IF NOT EXISTS public.direct_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Enable Row Level Security (RLS) on conversations
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

-- 4. Enable Row Level Security (RLS) on direct_messages
ALTER TABLE public.direct_messages ENABLE ROW LEVEL SECURITY;

-- 5. RLS Policies for conversations
-- Users can only see conversations they're part of
CREATE POLICY "Users can view their own conversations"
ON public.conversations FOR SELECT
USING (
  auth.uid() = user1_id OR auth.uid() = user2_id
);

-- Users can create conversations
CREATE POLICY "Users can create conversations"
ON public.conversations FOR INSERT
WITH CHECK (
  auth.uid() = user1_id OR auth.uid() = user2_id
);

-- 6. RLS Policies for direct_messages
-- Users can only see messages in conversations they're part of
CREATE POLICY "Users can view messages in their conversations"
ON public.direct_messages FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.conversations
    WHERE conversations.id = direct_messages.conversation_id
    AND (conversations.user1_id = auth.uid() OR conversations.user2_id = auth.uid())
  )
);

-- Users can send messages in conversations they're part of
CREATE POLICY "Users can send messages in their conversations"
ON public.direct_messages FOR INSERT
WITH CHECK (
  auth.uid() = sender_id
  AND EXISTS (
    SELECT 1 FROM public.conversations
    WHERE conversations.id = direct_messages.conversation_id
    AND (conversations.user1_id = auth.uid() OR conversations.user2_id = auth.uid())
  )
);

-- 7. Enable real-time replication for both tables
DO $$
BEGIN
  -- Add conversations to realtime publication
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
    AND tablename = 'conversations'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.conversations;
  END IF;

  -- Add direct_messages to realtime publication
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
    AND tablename = 'direct_messages'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.direct_messages;
  END IF;
END $$;

-- 8. Create indexes for faster queries
CREATE INDEX IF NOT EXISTS conversations_user1_idx ON public.conversations(user1_id);
CREATE INDEX IF NOT EXISTS conversations_user2_idx ON public.conversations(user2_id);
CREATE INDEX IF NOT EXISTS conversations_updated_at_idx ON public.conversations(updated_at DESC);
CREATE INDEX IF NOT EXISTS direct_messages_conversation_idx ON public.direct_messages(conversation_id);
CREATE INDEX IF NOT EXISTS direct_messages_created_at_idx ON public.direct_messages(created_at DESC);

-- 9. Function to update conversation updated_at when new message is sent
CREATE OR REPLACE FUNCTION public.update_conversation_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.conversations
  SET updated_at = NOW()
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 10. Trigger to update conversation timestamp on new message
CREATE TRIGGER update_conversation_on_message
  AFTER INSERT ON public.direct_messages
  FOR EACH ROW EXECUTE FUNCTION public.update_conversation_timestamp();


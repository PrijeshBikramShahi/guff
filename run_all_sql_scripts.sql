-- Combined SQL script to add all missing features
-- Run this SQL in your Supabase SQL Editor to fix all errors

-- ============================================
-- 1. Add read receipts to direct_messages
-- ============================================
ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS read_at TIMESTAMP WITH TIME ZONE;

ALTER TABLE public.conversations
ADD COLUMN IF NOT EXISTS last_read_message_id_user1 UUID REFERENCES public.direct_messages(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS last_read_message_id_user2 UUID REFERENCES public.direct_messages(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS direct_messages_read_at_idx ON public.direct_messages(read_at);

-- Create function to mark messages as read
CREATE OR REPLACE FUNCTION public.mark_messages_as_read(
  p_conversation_id UUID,
  p_user_id UUID
)
RETURNS void AS $$
DECLARE
  v_conversation public.conversations%ROWTYPE;
BEGIN
  -- Get conversation details
  SELECT * INTO v_conversation
  FROM public.conversations
  WHERE id = p_conversation_id
    AND (user1_id = p_user_id OR user2_id = p_user_id);

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Conversation not found or user not part of conversation';
  END IF;

  -- Mark all unread messages in this conversation as read
  UPDATE public.direct_messages
  SET read_at = NOW()
  WHERE conversation_id = p_conversation_id
    AND sender_id != p_user_id
    AND read_at IS NULL;

  -- Update last_read_message_id in conversations table
  IF v_conversation.user1_id = p_user_id THEN
    UPDATE public.conversations
    SET last_read_message_id_user1 = (
      SELECT id FROM public.direct_messages
      WHERE conversation_id = p_conversation_id
      ORDER BY created_at DESC
      LIMIT 1
    )
    WHERE id = p_conversation_id;
  ELSE
    UPDATE public.conversations
    SET last_read_message_id_user2 = (
      SELECT id FROM public.direct_messages
      WHERE conversation_id = p_conversation_id
      ORDER BY created_at DESC
      LIMIT 1
    )
    WHERE id = p_conversation_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.mark_messages_as_read(UUID, UUID) TO authenticated;

-- ============================================
-- 2. Create typing_indicators table
-- ============================================
CREATE TABLE IF NOT EXISTS public.typing_indicators (
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  is_typing BOOLEAN NOT NULL DEFAULT false,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (conversation_id, user_id)
);

ALTER TABLE public.typing_indicators ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view typing indicators in their conversations"
ON public.typing_indicators FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.conversations
    WHERE conversations.id = typing_indicators.conversation_id
    AND (conversations.user1_id = auth.uid() OR conversations.user2_id = auth.uid())
  )
);

CREATE POLICY "Users can update their own typing status"
ON public.typing_indicators FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can insert their own typing status"
ON public.typing_indicators FOR INSERT
WITH CHECK (auth.uid() = user_id);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
    AND tablename = 'typing_indicators'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.typing_indicators;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS typing_indicators_conversation_idx ON public.typing_indicators(conversation_id);
CREATE INDEX IF NOT EXISTS typing_indicators_updated_at_idx ON public.typing_indicators(updated_at);

-- ============================================
-- 3. Add image/file sharing columns
-- ============================================
ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'file'));

ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS file_url TEXT;

ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS file_name TEXT;

ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS file_size BIGINT;

CREATE INDEX IF NOT EXISTS direct_messages_type_idx ON public.direct_messages(message_type);

-- ============================================
-- 4. Add online status (last_seen)
-- ============================================
-- Note: DEFAULT NULL so existing users don't show as online immediately
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS last_seen TIMESTAMP WITH TIME ZONE;

CREATE INDEX IF NOT EXISTS users_last_seen_idx ON public.users(last_seen DESC);

CREATE OR REPLACE FUNCTION public.is_user_online(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.users
    WHERE id = user_id
    AND last_seen IS NOT NULL
    AND last_seen > NOW() - INTERVAL '2 minutes'
  );
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Done! All features should work now.
-- ============================================


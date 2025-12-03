-- Add read receipts functionality to direct messages
-- Run this SQL in your Supabase SQL Editor

-- 1. Add read_at column to direct_messages table
ALTER TABLE public.direct_messages
ADD COLUMN IF NOT EXISTS read_at TIMESTAMP WITH TIME ZONE;

-- 2. Add last_read_message_id to conversations table
-- This tracks the last message each user has read in a conversation
ALTER TABLE public.conversations
ADD COLUMN IF NOT EXISTS last_read_message_id_user1 UUID REFERENCES public.direct_messages(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS last_read_message_id_user2 UUID REFERENCES public.direct_messages(id) ON DELETE SET NULL;

-- 3. Create index for faster queries on read_at
CREATE INDEX IF NOT EXISTS direct_messages_read_at_idx ON public.direct_messages(read_at);

-- 4. Create function to mark messages as read
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
  -- (messages sent by the other user that haven't been read yet)
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

-- 5. Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.mark_messages_as_read(UUID, UUID) TO authenticated;


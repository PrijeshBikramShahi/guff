-- Add typing indicators functionality
-- Run this SQL in your Supabase SQL Editor

-- 1. Create typing_indicators table
CREATE TABLE IF NOT EXISTS public.typing_indicators (
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  is_typing BOOLEAN NOT NULL DEFAULT false,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (conversation_id, user_id)
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE public.typing_indicators ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies for typing_indicators
-- Users can view typing indicators in their conversations
CREATE POLICY "Users can view typing indicators in their conversations"
ON public.typing_indicators FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.conversations
    WHERE conversations.id = typing_indicators.conversation_id
    AND (conversations.user1_id = auth.uid() OR conversations.user2_id = auth.uid())
  )
);

-- Users can update their own typing status
CREATE POLICY "Users can update their own typing status"
ON public.typing_indicators FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Users can insert their own typing status
CREATE POLICY "Users can insert their own typing status"
ON public.typing_indicators FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 4. Enable real-time replication
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

-- 5. Create index for faster queries
CREATE INDEX IF NOT EXISTS typing_indicators_conversation_idx ON public.typing_indicators(conversation_id);
CREATE INDEX IF NOT EXISTS typing_indicators_updated_at_idx ON public.typing_indicators(updated_at);

-- 6. Create function to automatically clear typing status after 3 seconds
-- This is a safety mechanism in case the client doesn't clear it
CREATE OR REPLACE FUNCTION public.clear_old_typing_indicators()
RETURNS void AS $$
BEGIN
  UPDATE public.typing_indicators
  SET is_typing = false
  WHERE is_typing = true
    AND updated_at < NOW() - INTERVAL '3 seconds';
END;
$$ LANGUAGE plpgsql;


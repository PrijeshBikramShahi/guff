-- Add online/offline status functionality
-- Run this SQL in your Supabase SQL Editor

-- 1. Add last_seen column to users table
-- Note: DEFAULT NULL so existing users don't show as online immediately
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS last_seen TIMESTAMP WITH TIME ZONE;

-- 2. Create index for faster queries
CREATE INDEX IF NOT EXISTS users_last_seen_idx ON public.users(last_seen DESC);

-- 3. Create function to update last_seen timestamp
CREATE OR REPLACE FUNCTION public.update_last_seen()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.users
  SET last_seen = NOW()
  WHERE id = NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Create trigger to update last_seen when user signs in
-- Note: This is a simple approach. For real-time presence, consider using Supabase Realtime Presence API

-- 5. Create a view or function to check if user is online (within last 5 minutes)
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


# Step-by-Step Plan: Add Users Feature

## What "Add Users" Could Mean

1. **User List/Contacts** - See all registered users in the app
2. **Direct Messaging** - Chat one-on-one with specific users
3. **User Profiles** - View and edit user profiles
4. **Online Status** - See who's online/offline

## Recommended Approach: User List + Direct Messaging

This is the most common and useful feature for a chat app.

---

## Step-by-Step Implementation

### Step 1: Create Users Table in Supabase
**Goal:** Store user profiles (name, avatar, etc.)

**Tasks:**
- [ ] Create `users` table in Supabase
- [ ] Add fields: `id` (references auth.users), `display_name`, `avatar_url`, `created_at`, `updated_at`
- [ ] Set up RLS policies (users can read all, update own)
- [ ] Create trigger to auto-create user profile on signup

**SQL to run:**
```sql
-- Create users table
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read users (for user list)
CREATE POLICY "Users are viewable by everyone"
ON public.users FOR SELECT
USING (true);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile"
ON public.users FOR UPDATE
USING (auth.uid() = id);

-- Policy: Users can insert their own profile
CREATE POLICY "Users can insert own profile"
ON public.users FOR INSERT
WITH CHECK (auth.uid() = id);

-- Trigger to auto-create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, display_name)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

---

### Step 2: Create User Model
**Goal:** Flutter model for user data

**Tasks:**
- [ ] Create `lib/models/user.dart` (or rename `app_user.dart`)
- [ ] Add fields: `id`, `displayName`, `avatarUrl`, `email`
- [ ] Add `fromJson` and `toJson` methods

---

### Step 3: Create UserService
**Goal:** Service to fetch and manage users

**Tasks:**
- [ ] Create `lib/services/user_service.dart`
- [ ] Add method: `getAllUsers()` - fetch all users
- [ ] Add method: `getUserById(String userId)` - fetch specific user
- [ ] Add method: `updateUserProfile(String displayName, String? avatarUrl)` - update own profile
- [ ] Add method: `getCurrentUserProfile()` - get current user's profile

---

### Step 4: Update AuthService
**Goal:** Sync user profile on signup/signin

**Tasks:**
- [ ] After signup, create/update user profile in `users` table
- [ ] On signin, ensure user profile exists

---

### Step 5: Create UsersListScreen
**Goal:** Screen to show all users

**Tasks:**
- [ ] Create `lib/screens/users_list_screen.dart`
- [ ] Show list of all users with avatars/initials
- [ ] Show current user at top (or exclude from list)
- [ ] Add search/filter functionality (optional)
- [ ] Add navigation to user profile or chat

---

### Step 6: Update ChatScreen
**Goal:** Show which user you're chatting with

**Tasks:**
- [ ] Update app bar to show current chat context
- [ ] For group chat: "Guff Chat" (current)
- [ ] For direct message: Show other user's name/avatar

---

### Step 7: Add Navigation
**Goal:** Navigate between screens

**Tasks:**
- [ ] Add users list button in ChatScreen app bar
- [ ] Navigate to UsersListScreen
- [ ] From users list, navigate to chat (or create direct message)

---

### Step 8: Optional - Direct Messaging
**Goal:** One-on-one chats (more complex)

**Tasks:**
- [ ] Create `conversations` table (user1_id, user2_id, created_at)
- [ ] Create `direct_messages` table (conversation_id, sender_id, text, created_at)
- [ ] Update ChatScreen to support both group chat and direct messages
- [ ] Add conversation list screen

---

## Quick Start: Basic User List (Simplest)

If you just want to see users without direct messaging:

1. **Step 1:** Create users table (SQL above)
2. **Step 2:** Create User model
3. **Step 3:** Create UserService with `getAllUsers()`
4. **Step 4:** Create UsersListScreen
5. **Step 5:** Add navigation to users list

This gives you a user list without the complexity of direct messaging.

---

## Which Do You Want?

1. **Just User List** - See all users (simplest)
2. **User List + Direct Messaging** - Full chat app (more complex)
3. **User Profiles** - View/edit profiles (medium)

Let me know which one, and I'll implement it step by step!


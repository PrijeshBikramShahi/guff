# Direct Messaging Setup Instructions

## ✅ Code is Ready!

All Flutter code for direct messaging is implemented. Now you need to set up the database.

---

## Step 1: Run SQL Scripts in Supabase

### 1.1 Create Users Table

1. Go to Supabase Dashboard → SQL Editor
2. Open `create_users_table.sql`
3. Copy and paste the SQL into the editor
4. Click "Run"
5. Verify: Go to Table Editor → Should see `users` table

### 1.2 Create DM Tables

1. Still in SQL Editor
2. Open `create_dm_tables.sql`
3. Copy and paste the SQL into the editor
4. Click "Run"
5. Verify: Go to Table Editor → Should see `conversations` and `direct_messages` tables

---

## Step 2: Create User Profiles for Existing Users

If you already have users signed up, create their profiles:

```sql
-- Run this in SQL Editor
INSERT INTO public.users (id, display_name)
SELECT id, email FROM auth.users
WHERE id NOT IN (SELECT id FROM public.users);
```

---

## Step 3: Test the App

1. **Run the app:**
   ```bash
   flutter clean
   flutter run
   ```

2. **Sign up or sign in:**
   - New users will automatically get a profile created
   - Existing users need profiles (see Step 2)

3. **Start a conversation:**
   - You'll see "Messages" screen (conversations list)
   - Tap the "+" button (floating action button)
   - Select a user to start chatting
   - Send messages!

---

## App Flow

```
AuthScreen
  ↓ (sign in)
ConversationsListScreen (home)
  ├─→ ChatScreen (open existing conversation)
  └─→ UsersListScreen → ChatScreen (start new conversation)
```

---

## Features

✅ **Conversations List** - See all your DMs
✅ **Start New Chat** - Tap + button to select user
✅ **Real-time Messaging** - Messages update instantly
✅ **User Profiles** - Avatars and display names
✅ **Message Bubbles** - Your messages on right, theirs on left

---

## Troubleshooting

### "No conversations yet"
- This is normal if you haven't started any chats
- Tap the + button to start a new conversation

### "No other users found"
- Make sure at least 2 users have signed up
- Check that user profiles exist in `users` table

### "Error loading messages"
- Check RLS policies are set correctly
- Verify tables exist in Supabase
- Check console for specific error

### User profile not created on signup
- Check trigger `on_auth_user_created` exists
- Manually create profile (see Step 2)

---

## Next Steps (Optional)

- Add message timestamps
- Add read receipts
- Add typing indicators
- Add file/image sharing
- Add push notifications

---

## Database Tables

1. **users** - User profiles (display_name, avatar_url)
2. **conversations** - DM chat rooms (user1_id, user2_id)
3. **direct_messages** - Messages in conversations

All tables have RLS enabled for security!


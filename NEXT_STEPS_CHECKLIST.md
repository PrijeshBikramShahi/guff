# Next Steps Checklist

## ✅ Code is Complete!

All Flutter code for direct messaging is implemented and ready. Now you need to set up the database.

---

## Step 1: Create Database Tables in Supabase ⚠️ REQUIRED

### 1.1 Create Users Table

1. **Go to Supabase Dashboard:**
   - https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/sql/new

2. **Open the SQL file:**
   - Open `create_users_table.sql` in your project

3. **Copy and paste the SQL:**
   - Copy all SQL from `create_users_table.sql`
   - Paste into Supabase SQL Editor

4. **Run it:**
   - Click "Run" button (or press Cmd+Enter)
   - Should see "Success. No rows returned"

5. **Verify:**
   - Go to Table Editor → Should see `users` table
   - Check it has columns: `id`, `display_name`, `avatar_url`, `created_at`, `updated_at`

### 1.2 Create DM Tables (Conversations & Direct Messages)

1. **Still in SQL Editor:**
   - Clear the editor or open a new query

2. **Open the SQL file:**
   - Open `create_dm_tables.sql` in your project

3. **Copy and paste the SQL:**
   - Copy all SQL from `create_dm_tables.sql`
   - Paste into Supabase SQL Editor

4. **Run it:**
   - Click "Run" button
   - Should see "Success. No rows returned"

5. **Verify:**
   - Go to Table Editor → Should see:
     - `conversations` table
     - `direct_messages` table
   - Check columns are correct

---

## Step 2: Create User Profiles for Existing Users (If Needed)

If you already have users who signed up before, create their profiles:

1. **Go to SQL Editor again**

2. **Run this SQL:**
   ```sql
   INSERT INTO public.users (id, display_name)
   SELECT id, email FROM auth.users
   WHERE id NOT IN (SELECT id FROM public.users);
   ```

3. **Verify:**
   - Go to Table Editor → `users` table
   - Should see rows for existing users

**Note:** New users will automatically get profiles created (via trigger).

---

## Step 3: Test the App 🧪

### 3.1 Clean and Run

```bash
flutter clean
flutter pub get
flutter run
```

### 3.2 Test Flow

1. **Sign In:**
   - Use existing account or sign up new one
   - Should navigate to "Messages" screen (ConversationsListScreen)

2. **Start New Chat:**
   - Tap the "+" floating action button
   - Should see list of users (UsersListScreen)
   - Tap a user to start conversation
   - Should navigate to ChatScreen

3. **Send Messages:**
   - Type a message and send
   - Should appear in real-time
   - Your messages on right (blue), theirs on left (grey)

4. **View Conversations:**
   - Go back to Messages screen
   - Should see your conversation in the list
   - Tap to open it again

---

## Step 4: Verify Everything Works ✅

### Checklist:

- [ ] Users table exists in Supabase
- [ ] Conversations table exists
- [ ] Direct_messages table exists
- [ ] App runs without errors
- [ ] Can sign in/sign up
- [ ] See "Messages" screen after login
- [ ] Can see users list when tapping "+"
- [ ] Can start new conversation
- [ ] Can send messages
- [ ] Messages appear in real-time
- [ ] Can see conversation in list
- [ ] Can open existing conversation

---

## Troubleshooting

### "No conversations yet"
✅ **Normal!** This means you haven't started any chats yet.
- Tap the "+" button to start a new conversation

### "No other users found"
- Make sure at least 2 users have signed up
- Check `users` table has multiple rows
- Verify RLS policies allow reading users

### "Error loading messages"
- Check RLS policies on `direct_messages` table
- Verify you're authenticated
- Check console for specific error

### "Table doesn't exist" error
- Make sure you ran both SQL scripts
- Check Table Editor to verify tables exist
- Re-run the SQL scripts if needed

### User profile not created
- Check trigger `on_auth_user_created` exists
- Manually create profile (Step 2)
- Check console for errors

---

## What You Should See

### After Step 1:
- ✅ 3 new tables in Supabase: `users`, `conversations`, `direct_messages`

### After Step 2:
- ✅ User profiles in `users` table

### After Step 3:
- ✅ App shows "Messages" screen
- ✅ Can start conversations
- ✅ Can send/receive messages
- ✅ Real-time updates work

---

## Quick Start (TL;DR)

1. **Run SQL:** Copy `create_users_table.sql` → Supabase SQL Editor → Run
2. **Run SQL:** Copy `create_dm_tables.sql` → Supabase SQL Editor → Run
3. **Test:** `flutter run` → Sign in → Tap "+" → Start chatting!

---

## Need Help?

If something doesn't work:
1. Check Supabase Dashboard → Table Editor (tables exist?)
2. Check Supabase Dashboard → Authentication → Users (users exist?)
3. Check Flutter console for errors
4. Verify RLS policies are set correctly

Good luck! 🚀


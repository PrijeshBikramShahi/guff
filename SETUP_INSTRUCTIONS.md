# Setup Instructions

## Step 1: Supabase Setup ✅ (In Progress)

### 1. Create Supabase Project
1. Go to https://supabase.com
2. Sign up or log in
3. Click "New Project"
4. Fill in:
   - Project name: `guff-app` (or any name)
   - Database password: (choose a strong password)
   - Region: (choose closest to you)
5. Wait for project to be created (~2 minutes)

### 2. Get Your API Keys
1. In your Supabase project dashboard
2. Go to **Settings** → **API**
3. Copy:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public** key (long string starting with `eyJ...`)

### 3. Update main.dart
1. Open `lib/main.dart`
2. Replace `YOUR_SUPABASE_URL` with your Project URL
3. Replace `YOUR_SUPABASE_ANON_KEY` with your anon key
4. Save the file

### 4. Test Connection
Run the app:
```bash
flutter run
```

You should see in the console:
```
✅ Supabase initialized successfully!
```

If you see this, Step 1 is complete! 🎉

---

## Step 2: Create Messages Table ✅ (In Progress)

### Option A: Using SQL Editor (Recommended)

1. In your Supabase dashboard, go to **SQL Editor**
2. Click **New Query**
3. Copy and paste the contents of `supabase_setup.sql` (in your project root)
4. Click **Run** (or press Cmd/Ctrl + Enter)
5. You should see "Success. No rows returned"

### Option B: Using Table Editor (Visual)

1. In your Supabase dashboard, go to **Table Editor**
2. Click **New Table**
3. Table name: `messages`
4. Add columns:
   - `id` - Type: `uuid`, Primary key: ✅, Default: `gen_random_uuid()`
   - `text` - Type: `text`, Nullable: ❌
   - `user_id` - Type: `uuid`, Nullable: ❌, Foreign key: `auth.users(id)`
   - `user_name` - Type: `text`, Nullable: ❌
   - `user_avatar_url` - Type: `text`, Nullable: ✅
   - `created_at` - Type: `timestamptz`, Default: `now()`
5. Click **Save**

### Enable Real-time Replication

**Important:** The "Database → Replication" page you saw is for external data warehouses (BigQuery, etc.), NOT for real-time subscriptions.

For real-time chat, the SQL script already handles this with:
```sql
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
```

**To verify real-time is enabled:**
1. Go to **Database** → **Replication** (the page you saw)
2. Look for a section about "Real-time" or "Realtime" (not the external destinations)
3. OR simply run the SQL script - it will enable real-time automatically
4. Real-time is usually enabled by default for new tables in Supabase

**If you want to check manually via SQL:**
```sql
-- Check if table is in realtime publication
SELECT * FROM pg_publication_tables WHERE pubname = 'supabase_realtime';
```

You should see `messages` in the list.

### Setup Row Level Security (RLS)



1. Go to **Authentication** → **Policies**
2. Or use SQL Editor and run:
   ```sql
   ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
   
   CREATE POLICY "Allow authenticated users to read messages" 
   ON messages FOR SELECT 
   USING (auth.role() = 'authenticated');
   
   CREATE POLICY "Allow authenticated users to insert messages" 
   ON messages FOR INSERT 
   WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);
   ```

### Test the Table

1. Go to **Table Editor** → `messages`
2. Try inserting a test row manually (for now, you can use any UUID for user_id)
3. If it works, Step 2 is complete! 🎉

---

## Step 3 & 4: Flutter Models & Services ✅ (Complete)

The Message model and ChatService have been created! 

**Important:** For testing Steps 4-7 (before authentication), you need to temporarily allow public access:

1. Go to **SQL Editor** → **New Query**
2. Copy and paste the contents of `supabase_temp_public_access.sql`
3. Click **Run**
4. This allows the hardcoded test user to send/receive messages

**⚠️ Remember:** We'll restore proper authentication policies in Step 12!

---

## Next Steps
- **Step 5**: Create basic ChatScreen UI
- **Step 6**: Connect UI to ChatService
- **Step 7**: Add message input
- And so on...


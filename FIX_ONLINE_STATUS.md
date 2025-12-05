# Fix: Everyone Shows as Online

## 🔴 Problem

Everyone is showing as "Online" even when they're not.

## 🔍 Why This Happens

The `last_seen` column was created with `DEFAULT NOW()`, which means:
- All existing users got `last_seen = NOW()` when the column was added
- This makes them all appear online immediately

## ✅ Solution

### Step 1: Reset last_seen for Existing Users

Run this SQL in Supabase:

```sql
-- Set all existing users' last_seen to NULL
-- They'll show as offline until they actually use the app
UPDATE public.users
SET last_seen = NULL
WHERE last_seen IS NOT NULL;
```

Or use the file: `fix_online_status.sql`

### Step 2: Updated Code

I've already updated the code to:
- ✅ Only show as online if `last_seen` is within **2 minutes** (was 5 minutes)
- ✅ Require `last_seen IS NOT NULL` (was allowing null)
- ✅ More strict online detection

### Step 3: Rebuild App

```bash
flutter clean
flutter run
```

---

## How It Works Now

### Online Detection Rules:
1. **User must have `last_seen` set** (not NULL)
2. **`last_seen` must be within last 2 minutes**
3. **App updates `last_seen` every 2 minutes** while open

### What This Means:
- ✅ Users with app open = Online (green dot)
- ✅ Users who closed app = Offline (no dot, shows "Last seen X ago")
- ✅ Users who never used app = Offline (no dot, shows "Offline")

---

## Test It

1. **Run the SQL** to reset `last_seen`
2. **Rebuild the app**
3. **Sign in** - You should show as online (green dot)
4. **Close the app** - After 2+ minutes, you'll show as offline
5. **Open app again** - You'll show as online again

---

## If Still Showing Everyone Online

Check in Supabase:
1. Go to Table Editor → `users` table
2. Check `last_seen` column values
3. If they're all recent timestamps, run the reset SQL again
4. If they're NULL, that's correct - users will show offline until they use the app

---

## Customize Online Threshold

To change how long users stay "online" after closing app:

In `lib/models/chat_user.dart`, change:
```dart
return difference.inMinutes < 2; // Change 2 to your desired minutes
```

And in `lib/main.dart`, change update frequency:
```dart
Timer.periodic(const Duration(minutes: 2), ... // Change 2 to match
```

Good luck! 🚀


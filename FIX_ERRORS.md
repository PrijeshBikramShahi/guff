# Fix All Errors - Quick Guide

## 🔴 Errors You're Seeing

1. `column direct_messages.read_at does not exist` - Read receipts SQL not run
2. `Could not find the table 'public.typing_indicators'` - Typing indicators SQL not run
3. `Could not find the function public.mark_messages_as_read` - Read receipts function not created
4. `Timer isn't defined` - Missing import (FIXED in code)
5. `UserService isn't defined` - Missing import (FIXED in code)
6. Image picker error - iOS permissions (FIXED in Info.plist)

---

## ✅ Quick Fix: Run Combined SQL Script

I've created a **single SQL file** with all the missing database changes:

### Step 1: Run SQL Script

1. **Go to Supabase Dashboard → SQL Editor**
2. **Open `run_all_sql_scripts.sql`**
3. **Copy and paste ALL the SQL**
4. **Click "Run"**

This will create:
- ✅ `read_at` column for read receipts
- ✅ `mark_messages_as_read()` function
- ✅ `typing_indicators` table
- ✅ `message_type`, `file_url` columns for images
- ✅ `last_seen` column for online status

---

## ✅ Code Fixes Applied

I've already fixed:
- ✅ Added `dart:async` import for Timer
- ✅ Added `UserService` import
- ✅ Added iOS photo library permissions
- ✅ Added Android storage permissions

---

## Step 2: Rebuild App

After running the SQL:

```bash
flutter clean
flutter pub get
flutter run
```

---

## Step 3: Verify

After running SQL and rebuilding, you should see:
- ✅ No more "read_at does not exist" errors
- ✅ No more "typing_indicators table not found" errors
- ✅ No more "mark_messages_as_read function not found" errors
- ✅ Image picker should work (with permissions)

---

## If Errors Persist

### Check SQL Ran Successfully
1. Go to Supabase Dashboard → Table Editor
2. Check `direct_messages` table has:
   - `read_at` column ✅
   - `message_type` column ✅
   - `file_url` column ✅
3. Check `typing_indicators` table exists ✅
4. Check `users` table has `last_seen` column ✅

### Check Functions
1. Go to Supabase Dashboard → Database → Functions
2. Should see `mark_messages_as_read` function ✅

---

## Image Picker iOS Fix

If image picker still doesn't work on iOS:

1. **Stop the app completely**
2. **Rebuild:**
   ```bash
   flutter clean
   cd ios
   pod install
   cd ..
   flutter run
   ```

The permissions are now in `Info.plist`, so it should work after rebuild.

---

## Summary

**Run `run_all_sql_scripts.sql` in Supabase** → This fixes 90% of the errors!

Then rebuild the app and everything should work! 🚀


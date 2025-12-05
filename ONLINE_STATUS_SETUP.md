# Online/Offline Status Setup Instructions

## ✅ Code is Ready!

All Flutter code for online/offline status is implemented. Now you need to set up the database.

---

## Step 1: Run SQL Script

1. **Go to Supabase Dashboard → SQL Editor**
2. **Open `add_online_status.sql`**
3. **Copy and paste the SQL**
4. **Click "Run"**

This adds:
- `last_seen` column to `users` table
- Index for faster queries
- Function to check if user is online

---

## Step 2: Test Online Status

1. **Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```

2. **Sign in with two different accounts** (on different devices/emulators)

3. **Check online status:**
   - Green dot on avatar = Online
   - No dot = Offline
   - "Online" text in chat header
   - "2m ago", "1h ago" etc. for offline users

---

## How It Works

### Online Detection
- User is considered **online** if `last_seen` is within the last **5 minutes**
- `last_seen` is updated:
  - Every 2 minutes while app is open
  - Immediately when user signs in
  - When app comes to foreground

### Visual Indicators
- **Green dot** on avatar = Online
- **"Online"** text = Currently online
- **"2m ago"** etc. = Last seen time
- **"Offline"** = Not seen recently

### Where You'll See It
1. **Conversations List** - Green dot on user avatars
2. **Chat Screen** - "Online" or last seen in app bar
3. **Users List** - Green dot and status text

---

## Features

✅ **Automatic Updates** - Updates every 2 minutes
✅ **Visual Indicators** - Green dots on avatars
✅ **Status Text** - "Online" or "Last seen X ago"
✅ **Real-time** - Status updates when users come online/offline

---

## Customization

### Change Online Threshold
In `lib/models/chat_user.dart`, change:
```dart
return difference.inMinutes < 5; // Change 5 to your desired minutes
```

### Change Update Frequency
In `lib/main.dart`, change:
```dart
Timer.periodic(const Duration(minutes: 2), ... // Change 2 to your desired minutes
```

---

## Troubleshooting

### Status not updating
- Check SQL script ran successfully
- Verify `last_seen` column exists in `users` table
- Check console for errors

### Always shows "Offline"
- Check if `last_seen` is being updated
- Verify user is authenticated
- Check database for `last_seen` values

### Status updates too slowly
- Reduce update interval in `main.dart`
- Reduce online threshold in `chat_user.dart`

---

## Advanced: Real-time Presence (Future Enhancement)

For more accurate real-time presence, consider using:
- Supabase Realtime Presence API
- WebSocket connections
- Push notifications for status changes

The current implementation uses periodic updates, which is simpler but less real-time.

---

## Next Steps

After online status works, you can add:
- "Last seen" privacy settings
- Show "typing..." when online
- Online users list
- Status messages ("Available", "Busy", etc.)

Good luck! 🚀


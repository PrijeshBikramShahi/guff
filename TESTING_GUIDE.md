# Testing Guide - Direct Messaging App

## ✅ Database Setup Complete!

Now let's test the app to make sure everything works.

---

## Step 1: Run the App

```bash
flutter clean
flutter pub get
flutter run
```

---

## Step 2: Test Authentication

### 2.1 Sign Up (if needed)
- Enter email and password (min 8 chars, letters + digits)
- Click "Sign Up"
- Should navigate to "Messages" screen automatically

### 2.2 Sign In (if you have account)
- Enter email and password
- Click "Sign In"
- Should navigate to "Messages" screen

**Expected:** You should see the "Messages" screen (ConversationsListScreen) with:
- App bar title: "Messages"
- Logout button (top right)
- "+" floating action button (bottom right)
- Either empty state ("No conversations yet") or list of conversations

---

## Step 3: Test User List

### 3.1 Open Users List
- Tap the "+" floating action button
- Should navigate to "New Chat" screen (UsersListScreen)

### 3.2 Verify Users
- Should see list of other users (not yourself)
- Each user should show:
  - Avatar/initials
  - Display name or email
- If you see "No other users found":
  - Make sure at least 2 users have signed up
  - Check `users` table in Supabase has multiple rows

---

## Step 4: Start a Conversation

### 4.1 Start New Chat
- Tap on a user from the list
- Should navigate to ChatScreen
- App bar should show:
  - Back arrow (to go back to conversations)
  - User's avatar and name

### 4.2 Verify Chat Screen
- Should see empty state: "No messages yet. Send a message to get started!"
- Message input at bottom
- Send button (paper plane icon)

---

## Step 5: Send Messages

### 5.1 Send First Message
- Type a message in the input field
- Tap send button or press Enter
- Message should appear:
  - On the RIGHT side (blue bubble)
  - With your avatar on the right

### 5.2 Test Real-time (Use Second Device/User)
- Sign in with a different user account (on another device/emulator)
- Start conversation with the first user
- Send a message from second user
- First user should see message appear in real-time:
  - On the LEFT side (grey bubble)
  - With other user's avatar on the left

---

## Step 6: Test Conversations List

### 6.1 Go Back to Conversations
- Tap back arrow in ChatScreen
- Should return to "Messages" screen

### 6.2 Verify Conversation Appears
- Should see your conversation in the list
- Should show:
  - Other user's avatar
  - Other user's name
  - Last message preview
  - Timestamp

### 6.3 Open Existing Conversation
- Tap on a conversation in the list
- Should open ChatScreen with all messages
- Messages should be in correct order (newest at bottom)

---

## Step 7: Test Multiple Conversations

### 7.1 Start Another Conversation
- Tap "+" button again
- Select a different user
- Start chatting

### 7.2 Verify Both Conversations
- Go back to Messages screen
- Should see both conversations
- Most recently updated conversation should be at top

---

## Expected Behavior Checklist

### ✅ Authentication
- [ ] Can sign up new user
- [ ] Can sign in existing user
- [ ] Navigates to Messages screen after login
- [ ] Logout button works

### ✅ Users List
- [ ] Can see list of other users
- [ ] Users show avatars/initials
- [ ] Can tap user to start conversation

### ✅ Conversations
- [ ] Can start new conversation
- [ ] Conversation appears in list
- [ ] Can open existing conversation
- [ ] Conversations sorted by most recent

### ✅ Messaging
- [ ] Can send messages
- [ ] Messages appear immediately
- [ ] Your messages on right (blue)
- [ ] Their messages on left (grey)
- [ ] Real-time updates work (test with 2 users)

### ✅ Navigation
- [ ] Can navigate between screens
- [ ] Back button works correctly
- [ ] Floating action button works

---

## Common Issues & Fixes

### Issue: "No other users found"
**Fix:**
- Make sure at least 2 users have signed up
- Check `users` table in Supabase has multiple rows
- Verify RLS policy allows reading users

### Issue: "Error loading messages"
**Fix:**
- Check RLS policies on `direct_messages` table
- Verify you're authenticated
- Check console for specific error

### Issue: Messages not appearing in real-time
**Fix:**
- Check real-time is enabled on `direct_messages` table
- Verify WebSocket connection (check console)
- Try refreshing the screen

### Issue: Can't send messages
**Fix:**
- Check RLS policy on `direct_messages` INSERT
- Verify conversation exists
- Check console for errors

### Issue: User profile not created
**Fix:**
- Check trigger `on_auth_user_created` exists
- Manually create profile:
  ```sql
  INSERT INTO public.users (id, display_name)
  VALUES ('your-user-id', 'your-email@example.com');
  ```

---

## Testing with Multiple Users

### Option 1: Two Emulators/Simulators
1. Run app on iOS Simulator
2. Run app on Android Emulator (or another iOS Simulator)
3. Sign in with different accounts
4. Start conversation between them

### Option 2: Physical Device + Emulator
1. Run app on physical device
2. Run app on emulator
3. Sign in with different accounts
4. Test real-time messaging

### Option 3: Same Device (Limited)
- Sign out and sign in with different account
- Can test UI but not real-time (same session)

---

## Success Indicators 🎉

You'll know everything works when:

1. ✅ Can sign in and see Messages screen
2. ✅ Can see list of users
3. ✅ Can start new conversation
4. ✅ Can send and receive messages
5. ✅ Messages appear in real-time (with 2 users)
6. ✅ Conversations list updates automatically
7. ✅ Can open existing conversations
8. ✅ Message bubbles show correctly (yours right, theirs left)

---

## Next Steps After Testing

Once everything works, you can add:

- [ ] Message timestamps
- [ ] Read receipts
- [ ] Typing indicators
- [ ] Image/file sharing
- [ ] Push notifications
- [ ] Search conversations
- [ ] Delete conversations
- [ ] User profile editing

---

## Need Help?

If something doesn't work:
1. Check Flutter console for errors
2. Check Supabase Dashboard → Table Editor (data exists?)
3. Check Supabase Dashboard → Authentication → Logs
4. Verify RLS policies are correct
5. Check network connection

Good luck testing! 🚀


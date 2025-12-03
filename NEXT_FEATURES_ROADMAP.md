# Next Features & Implementation Roadmap

## 🎯 Current Status

✅ **Completed:**
- Email/password authentication
- User profiles
- Direct messaging (DMs)
- Real-time messaging
- Conversations list
- Basic message bubbles
- Navigation flow

---

## 🚀 Next Features to Implement (Priority Order)

### **High Priority** (Core Chat Features)

#### 1. Message Timestamps ⏰
**What:** Show when messages were sent
**Why:** Essential for chat apps
**Implementation:**
- Add timestamp below each message bubble
- Show relative time (e.g., "2m ago", "Yesterday", "Jan 15")
- Or show full time on long press
- Update `DirectMessage` model if needed
- Add time formatting utility

**Files to modify:**
- `lib/screens/chat_screen.dart` - Add timestamp widget
- `lib/models/direct_message.dart` - Already has `createdAt`

**Estimated effort:** 1-2 hours

---

#### 2. Auto-Scroll to New Messages 📜
**What:** Automatically scroll to bottom when new messages arrive
**Why:** Better UX - users don't have to manually scroll
**Implementation:**
- Add `ScrollController` to ListView
- Scroll to bottom when:
  - New message arrives (from stream)
  - User sends a message
  - Chat screen opens
- Optional: Scroll to bottom button if user scrolls up

**Files to modify:**
- `lib/screens/chat_screen.dart` - Add ScrollController

**Estimated effort:** 1 hour

---

#### 3. User Profile Editing 👤
**What:** Let users edit their display name and avatar
**Why:** Personalization
**Implementation:**
- Create `ProfileScreen`
- Edit display name
- Upload/change avatar (image picker)
- Update `UserService.updateProfile()`
- Add navigation from conversations list

**Files to create:**
- `lib/screens/profile_screen.dart`

**Files to modify:**
- `lib/services/user_service.dart` - Already has `updateProfile()`
- `lib/screens/conversations_list_screen.dart` - Add profile button

**Estimated effort:** 2-3 hours

---

### **Medium Priority** (Enhanced Features)

#### 4. Read Receipts ✓✓
**What:** Show when messages are read
**Why:** Users want to know if messages were seen
**Implementation:**
- Add `read_at` column to `direct_messages` table
- Add `last_read_message_id` to `conversations` table
- Update read status when user opens conversation
- Show read indicator (double checkmark) on messages
- Update in real-time

**Database changes:**
- Add columns to existing tables
- Create migration SQL

**Files to modify:**
- `lib/models/direct_message.dart` - Add `readAt`
- `lib/services/conversation_service.dart` - Add `markAsRead()`
- `lib/screens/chat_screen.dart` - Show read indicators

**Estimated effort:** 3-4 hours

---

#### 5. Typing Indicators ⌨️
**What:** Show when other user is typing
**Why:** Better real-time feel
**Implementation:**
- Create `typing_indicators` table or use Supabase presence
- Track typing state (start/stop)
- Show "User is typing..." in chat
- Update in real-time

**Database changes:**
- New table or use Supabase Realtime presence

**Files to create:**
- `lib/services/typing_service.dart`

**Files to modify:**
- `lib/screens/chat_screen.dart` - Show typing indicator

**Estimated effort:** 3-4 hours

---

#### 6. Image/File Sharing 📷
**What:** Send images and files in messages
**Why:** Essential for modern chat
**Implementation:**
- Add `message_type` column (text, image, file)
- Add `file_url` column to `direct_messages`
- Use image picker for photos
- Upload to Supabase Storage
- Display images in chat
- Show file previews

**Database changes:**
- Add columns to `direct_messages`
- Set up Supabase Storage bucket

**Files to modify:**
- `lib/models/direct_message.dart` - Add type and fileUrl
- `lib/services/conversation_service.dart` - Add file upload
- `lib/screens/chat_screen.dart` - Show images/files

**Estimated effort:** 4-6 hours

---

#### 7. Search Conversations 🔍
**What:** Search through conversations and messages
**Why:** Find old conversations easily
**Implementation:**
- Add search bar in ConversationsListScreen
- Filter conversations by user name
- Optional: Search within messages
- Use Supabase full-text search

**Files to modify:**
- `lib/screens/conversations_list_screen.dart` - Add search
- `lib/services/conversation_service.dart` - Add search method

**Estimated effort:** 2-3 hours

---

#### 8. Delete Conversations 🗑️
**What:** Remove conversations from list
**Why:** Privacy and organization
**Implementation:**
- Add swipe-to-delete or long-press menu
- Soft delete (mark as deleted) or hard delete
- Confirm dialog before deleting
- Update UI after deletion

**Files to modify:**
- `lib/screens/conversations_list_screen.dart` - Add delete action
- `lib/services/conversation_service.dart` - Add delete method

**Estimated effort:** 1-2 hours

---

### **Low Priority** (Nice to Have)

#### 9. Online/Offline Status 🟢
**What:** Show if users are online or offline
**Why:** Know when users are available
**Implementation:**
- Track last active time
- Use Supabase Realtime presence
- Show green dot for online users
- Show "last seen" time

**Estimated effort:** 3-4 hours

---

#### 10. Push Notifications 📲
**What:** Notify users of new messages
**Why:** Users want notifications when app is closed
**Implementation:**
- Set up Firebase Cloud Messaging (FCM)
- Configure Supabase Edge Functions for notifications
- Send push notifications on new messages
- Handle notification taps

**Estimated effort:** 4-6 hours

---

#### 11. Message Reactions 😀
**What:** React to messages with emojis
**Why:** Quick responses without typing
**Implementation:**
- Add `reactions` column (JSON) to `direct_messages`
- Long-press message to show reaction picker
- Show reactions below messages
- Update in real-time

**Estimated effort:** 3-4 hours

---

#### 12. Message Status Indicators 📊
**What:** Show sent/delivered/read status
**Why:** Users want to know message status
**Implementation:**
- Single checkmark = sent
- Double checkmark = delivered
- Blue checkmark = read
- Show in message bubble

**Estimated effort:** 2-3 hours

---

#### 13. Better Message Bubbles 💬
**What:** Improve message bubble styling
**Why:** Better visual design
**Implementation:**
- Rounded corners
- Better colors
- Shadow effects
- Group consecutive messages from same user
- Show avatar only on first message

**Estimated effort:** 2-3 hours

---

#### 14. Pull to Refresh 🔄
**What:** Pull down to refresh conversations
**Why:** Manual refresh option
**Implementation:**
- Add RefreshIndicator to conversations list
- Reload conversations on pull

**Estimated effort:** 30 minutes

---

#### 15. Message Search 🔎
**What:** Search within a conversation
**Why:** Find specific messages
**Implementation:**
- Add search bar in ChatScreen
- Filter messages by text
- Highlight search results
- Scroll to found message

**Estimated effort:** 2-3 hours

---

## 📋 Recommended Implementation Order

### Phase 1: Core Polish (1-2 days)
1. ✅ Message Timestamps
2. ✅ Auto-Scroll to New Messages
3. ✅ User Profile Editing

### Phase 2: Enhanced Features (3-5 days)
4. ✅ Read Receipts
5. ✅ Typing Indicators
6. ✅ Image/File Sharing

### Phase 3: Advanced Features (1-2 weeks)
7. ✅ Search Conversations
8. ✅ Delete Conversations
9. ✅ Online/Offline Status
10. ✅ Push Notifications

### Phase 4: Polish & Nice-to-Have (ongoing)
11. ✅ Message Reactions
12. ✅ Better Message Bubbles
13. ✅ Message Status Indicators
14. ✅ Pull to Refresh
15. ✅ Message Search

---

## 🎯 Quick Wins (Start Here!)

These are the easiest and most impactful features:

1. **Message Timestamps** - Simple, high impact
2. **Auto-Scroll** - Simple, improves UX significantly
3. **Better Message Bubbles** - Visual improvement, not too complex

---

## 💡 Feature Ideas for Future

- Voice messages
- Video calls
- Group chats (multiple users)
- Message forwarding
- Starred messages
- Message editing/deleting
- Dark mode toggle
- Custom themes
- Message drafts
- Scheduled messages
- Chat backup/export

---

## 🚀 What Should We Build Next?

I recommend starting with:
1. **Message Timestamps** - Quick win, essential feature
2. **Auto-Scroll** - Easy, big UX improvement
3. **User Profile Editing** - Users want to customize

Which feature would you like to implement first? I can help you build any of these!


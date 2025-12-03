# Direct Messaging (DM) Implementation Plan

## Overview
Convert from group chat to private direct messaging between users.

## Database Structure

### Tables Needed:
1. **users** - User profiles (display_name, avatar_url)
2. **conversations** - DM chat rooms between two users
3. **direct_messages** - Messages in conversations

### Key Design Decisions:
- Each conversation is between exactly 2 users (user1_id, user2_id)
- user1_id < user2_id to prevent duplicate conversations
- Messages reference conversation_id
- Real-time updates for both conversations and messages

---

## Step-by-Step Implementation

### Step 1: Database Setup ✅
**Files:**
- `create_users_table.sql` - Users table
- `create_dm_tables.sql` - Conversations and direct_messages tables

**Tasks:**
- [ ] Run `create_users_table.sql` in Supabase
- [ ] Run `create_dm_tables.sql` in Supabase
- [ ] Verify tables are created
- [ ] Verify RLS policies are working

---

### Step 2: Create Models
**Files:**
- `lib/models/user.dart` - User model
- `lib/models/conversation.dart` - Conversation model
- `lib/models/direct_message.dart` - Direct message model

**Tasks:**
- [ ] Create User model (id, displayName, avatarUrl, email)
- [ ] Create Conversation model (id, user1Id, user2Id, createdAt, updatedAt)
- [ ] Create DirectMessage model (id, conversationId, senderId, text, createdAt)
- [ ] Add helper methods (getOtherUserId, isCurrentUser, etc.)

---

### Step 3: Create Services
**Files:**
- `lib/services/user_service.dart` - Fetch users
- `lib/services/conversation_service.dart` - Manage conversations and DMs

**Tasks:**
- [ ] UserService: `getAllUsers()`, `getUserById()`
- [ ] ConversationService: 
  - `getAllConversations()` - Get user's conversations
  - `getOrCreateConversation(String otherUserId)` - Start/find conversation
  - `getMessagesStream(String conversationId)` - Real-time messages
  - `sendMessage(String conversationId, String text)` - Send DM

---

### Step 4: Create Screens
**Files:**
- `lib/screens/conversations_list_screen.dart` - List of all conversations
- `lib/screens/users_list_screen.dart` - List of users to start chat
- `lib/screens/chat_screen.dart` - Updated for DM mode

**Tasks:**
- [ ] ConversationsListScreen:
  - Show list of conversations
  - Show last message preview
  - Show other user's name/avatar
  - Tap to open chat
- [ ] UsersListScreen:
  - Show all users (except current user)
  - Tap user to start conversation
  - Navigate to ChatScreen
- [ ] Update ChatScreen:
  - Accept conversationId parameter
  - Show other user's name in app bar
  - Load messages for specific conversation
  - Send messages to conversation

---

### Step 5: Update Navigation
**Files:**
- `lib/main.dart` - Update app flow

**Tasks:**
- [ ] Change home screen to ConversationsListScreen (instead of ChatScreen)
- [ ] Add navigation:
  - ConversationsListScreen → ChatScreen (open conversation)
  - ConversationsListScreen → UsersListScreen (new chat)
  - UsersListScreen → ChatScreen (start conversation)
  - ChatScreen → ConversationsListScreen (back)

---

### Step 6: Update AuthService
**Files:**
- `lib/services/auth_service.dart`

**Tasks:**
- [ ] On signup, create user profile in users table
- [ ] Ensure user profile exists on signin

---

## App Flow

### Current Flow (Group Chat):
```
AuthScreen → ChatScreen (all messages)
```

### New Flow (DMs):
```
AuthScreen → ConversationsListScreen
  ├─→ ChatScreen (open existing conversation)
  └─→ UsersListScreen → ChatScreen (start new conversation)
```

---

## UI/UX Considerations

1. **ConversationsListScreen:**
   - List of conversations sorted by updated_at (most recent first)
   - Each item shows:
     - Other user's avatar/name
     - Last message preview
     - Timestamp
   - Floating action button to start new chat

2. **UsersListScreen:**
   - List of all users
   - Exclude current user
   - Show avatars/initials
   - Search/filter (optional)

3. **ChatScreen:**
   - Show other user's name in app bar
   - Back button to conversations list
   - Message bubbles (your messages on right, theirs on left)
   - Real-time updates

---

## Testing Checklist

- [ ] Can create user profile on signup
- [ ] Can see all users in users list
- [ ] Can start new conversation with user
- [ ] Can send and receive messages in DM
- [ ] Real-time updates work
- [ ] Can see conversation list
- [ ] Can open existing conversation
- [ ] Messages show correct sender
- [ ] RLS policies prevent unauthorized access

---

## Migration Notes

**Old messages table:**
- Can be kept for reference or removed
- New messages go to direct_messages table
- Group chat functionality can be added back later if needed

**Existing users:**
- Need to create profiles in users table
- SQL provided in create_users_table.sql comments


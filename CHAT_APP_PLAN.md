# Flutter Chat App - Implementation Plan

## Overview
Build a minimal chat application that allows users to send and receive messages in real-time.

---

## MVP Features (Minimum Viable Product)

### Core MVP Features (Must Have)
1. ✅ **Google OAuth Login** - Users can sign in with Google
2. ✅ **Send Messages** - Authenticated users can send text messages
3. ✅ **View Messages** - Users can see all messages in real-time
4. ✅ **User Identification** - Messages show who sent them (name/avatar)

### Nice to Have (Post-MVP)
- Message timestamps
- Logout functionality
- Loading states
- Error handling
- Message avatars
- Auto-scroll to latest message

---

## Incremental Development Steps (Small Steps)

### Step 1: Basic Setup (No UI)
- [ ] Setup Supabase project
- [ ] Add `supabase_flutter` dependency
- [ ] Initialize Supabase in `main.dart`
- [ ] Test connection (just print "Connected" in console)

### Step 2: Database Setup
- [ ] Create `messages` table in Supabase
- [ ] Create basic RLS policies (allow all for now)
- [ ] Enable real-time replication
- [ ] Test: Manually insert a message via Supabase dashboard

### Step 3: Message Model
- [ ] Create `Message` model class
- [ ] Add `fromJson()` method
- [ ] Test: Create a Message object from hardcoded JSON

### Step 4: Basic Chat Service (No Auth Yet)
- [ ] Create `ChatService` class
- [ ] Add `getMessages()` method (returns Future, not stream yet)
- [ ] Add `sendMessage()` method (hardcode user_id for now)
- [ ] Test: Send and retrieve messages from Flutter

### Step 5: Simple UI - Message List
- [ ] Create basic `ChatScreen` (no auth check yet)
- [ ] Display hardcoded messages in ListView
- [ ] Test: See messages on screen

### Step 6: Connect UI to Service
- [ ] Load messages from Supabase in ChatScreen
- [ ] Display real messages (still hardcoded user)
- [ ] Test: See real messages from database

### Step 7: Message Input
- [ ] Add TextField and Send button
- [ ] Send message when button clicked (still hardcoded user)
- [ ] Test: Send message and see it appear

### Step 8: Real-time Updates
- [ ] Change `getMessages()` to return Stream
- [ ] Listen to stream in ChatScreen
- [ ] Test: Send message from another device/browser, see it appear instantly

### Step 9: Google OAuth Setup
- [ ] Configure Google OAuth in Supabase
- [ ] Setup Google Cloud Console credentials
- [ ] Test: OAuth redirect works (can skip actual login for now)

### Step 10: Auth Service
- [ ] Create `AuthService` class
- [ ] Add `signInWithGoogle()` method
- [ ] Add `getCurrentUser()` method
- [ ] Test: Print user info after login

### Step 11: Auth Screen
- [ ] Create `AuthScreen` with Google sign-in button
- [ ] Handle OAuth callback
- [ ] Test: Can sign in with Google

### Step 12: Connect Auth to Chat
- [ ] Check auth state on app start
- [ ] Show AuthScreen if not logged in
- [ ] Show ChatScreen if logged in
- [ ] Use real user_id when sending messages
- [ ] Test: Full flow - login → send message → see your name

### Step 13: User Info in Messages
- [ ] Update `sendMessage()` to use user name/avatar from auth
- [ ] Display sender name in messages
- [ ] Test: Messages show correct sender names

### Step 14: Message Bubbles (Styling)
- [ ] Create `MessageBubble` widget
- [ ] Different styling for sent vs received
- [ ] Test: Messages look nice

### Step 15: Polish
- [ ] Add logout button
- [ ] Add loading indicators
- [ ] Add error handling
- [ ] Auto-scroll to bottom
- [ ] Test: Everything works smoothly

---

## Recommended Development Order

**Week 1: Backend & Basic Functionality**
- Steps 1-7: Get basic chat working (no auth, hardcoded user)

**Week 2: Authentication**
- Steps 8-12: Add Google OAuth and connect to chat

**Week 3: Polish**
- Steps 13-15: User info, styling, and polish

---

## MVP Checklist (Simplified)

### Must Complete for MVP:
- [ ] User can sign in with Google
- [ ] User can send a text message
- [ ] User can see all messages in real-time
- [ ] Messages show sender name

### Can Skip for MVP:
- ❌ Message timestamps (add later)
- ❌ User avatars (add later)
- ❌ Logout button (add later)
- ❌ Error messages (add later)
- ❌ Loading states (add later)
- ❌ Message search (add later)
- ❌ Multiple chat rooms (add later)

## Technology Stack

### Supabase with Google OAuth
- **Technology**: PostgreSQL with real-time subscriptions (WebSocket-based via replication)
- **Authentication**: Google OAuth via Supabase Auth
- **Pros**: 
  - True WebSocket support for real-time updates
  - Managed service with generous free tier
  - Built-in Google OAuth authentication
  - Admin dashboard (Table Editor)
  - PostgreSQL database (powerful and familiar)
  - REST API + real-time subscriptions
  - Auto-generated APIs
  - Row Level Security (RLS) for permissions
  - User management built-in
- **Cons**: Requires account (but free tier is generous), internet connection
- **Packages**: `supabase_flutter` (official Flutter SDK)
- **Setup**: Create project at supabase.com, configure Google OAuth, get API keys, create table

---

## Step-by-Step Implementation Checklist

### Phase 1: Project Setup & Supabase Configuration
- [ ] **1.1** Create account and project at https://supabase.com
- [ ] **1.2** Get your project URL and anon key from Settings → API
- [ ] **1.3** Configure Google OAuth in Supabase:
  - Go to Authentication → Providers → Google
  - Enable Google provider
  - Get Google OAuth credentials from Google Cloud Console:
    - Create project at https://console.cloud.google.com
    - Enable Google+ API
    - Create OAuth 2.0 credentials (Web application)
    - Add authorized redirect URI: `https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback`
    - Copy Client ID and Client Secret to Supabase
- [ ] **1.4** Create `messages` table in Table Editor:
  - Table name: `messages`
  - Columns:
    - `id` (uuid, primary key, default: gen_random_uuid())
    - `text` (text, not null)
    - `user_id` (uuid, foreign key to auth.users, not null)
    - `user_name` (text, not null) - can be derived from auth.users
    - `user_avatar_url` (text, nullable) - for profile picture
    - `created_at` (timestamp, default: now())
- [ ] **1.5** Enable Row Level Security (RLS) on messages table
- [ ] **1.6** Create RLS policies for messages:
  - Allow authenticated users to read all messages
  - Allow authenticated users to insert their own messages
- [ ] **1.7** Enable real-time replication for `messages` table
- [ ] **1.8** Add Supabase dependency: `flutter pub add supabase_flutter`
- [ ] **1.9** Run `flutter pub get`
- [ ] **1.10** Initialize Supabase in `main.dart`

### Phase 2: Data Models
- [ ] **2.1** Create `lib/models/message.dart`
  - Fields: `id` (String), `text` (String), `userId` (String), `userName` (String), `userAvatarUrl` (String?), `createdAt` (DateTime)
  - Methods: `toJson()`, `fromJson()`, `fromSupabase()`
- [ ] **2.2** Create `lib/models/app_user.dart`
  - Fields: `id` (String), `email` (String?), `name` (String?), `avatarUrl` (String?)
  - Methods: `fromSupabaseUser(User user)`

### Phase 3: UI Components
- [ ] **3.1** Create `lib/widgets/message_bubble.dart`
  - Display message text
  - Different styling for sent vs received messages
  - Show sender name and timestamp
- [ ] **3.2** Create `lib/widgets/message_input.dart`
  - Text field for typing messages
  - Send button
  - Clear input after sending

### Phase 4: Authentication & Main Screens
- [ ] **4.1** Create `lib/screens/auth_screen.dart`
  - Google sign-in button
  - Handle authentication state
  - Show loading state during sign-in
  - Navigate to chat screen after successful login
- [ ] **4.2** Create `lib/screens/chat_screen.dart`
  - AppBar with chat title and user profile/logout
  - ListView/ListView.builder for messages
  - Message input at bottom
  - Scroll to bottom when new messages arrive
  - Show current user's avatar/name in AppBar
- [ ] **4.3** Implement authentication state management
  - Check if user is logged in on app start
  - Show auth screen if not authenticated
  - Show chat screen if authenticated

### Phase 5: Backend Integration & Authentication
- [ ] **5.1** Create `lib/services/auth_service.dart`
  - Method: `signInWithGoogle()` - Use `supabase.auth.signInWithOAuth(OAuthProvider.google)`
  - Method: `signOut()` - Use `supabase.auth.signOut()`
  - Stream: `authStateChanges()` - Listen to authentication state
  - Get current user: `supabase.auth.currentUser`
- [ ] **5.2** Create `lib/services/chat_service.dart`
  - Initialize Supabase client: `Supabase.instance.client`
  - Method: `sendMessage(Message message)` - Use authenticated user's ID
    - Get current user from `supabase.auth.currentUser`
    - Insert message with `user_id`, `user_name`, `user_avatar_url` from auth user
  - Stream: `getMessages()` - Use `supabase.from('messages').stream()` for real-time
  - Handle real-time subscriptions with PostgreSQL replication
- [ ] **5.3** Connect UI to services
  - Handle Google sign-in in AuthScreen
  - Listen to message stream in ChatScreen
  - Call sendMessage when user sends a message (use authenticated user info)
  - Handle connection status and authentication errors

### Phase 6: State Management
- [ ] **6.1** Choose approach:
  - **Simple**: StatefulWidget with setState
  - **Better**: Provider or Riverpod for state management
- [ ] **6.2** Implement message list state
  - Store messages in state
  - Update UI when new messages arrive

### Phase 7: Polish & Error Handling
- [ ] **7.1** Add loading indicators
- [ ] **7.2** Handle empty message list state
- [ ] **7.3** Add error handling for failed sends
- [ ] **7.4** Validate message input (non-empty)
- [ ] **7.5** Auto-scroll to latest message

### Phase 8: Testing
- [ ] **8.1** Test on multiple devices/emulators
- [ ] **8.2** Verify real-time updates work
- [ ] **8.3** Test message sending and receiving
- [ ] **8.4** Test with different users

---

## File Structure
```
lib/
├── main.dart
├── models/
│   ├── message.dart
│   └── app_user.dart
├── screens/
│   ├── auth_screen.dart
│   └── chat_screen.dart
├── widgets/
│   ├── message_bubble.dart
│   └── message_input.dart
└── services/
    ├── auth_service.dart
    └── chat_service.dart
```

---

## Database Structure

### Supabase Table: `messages`
**Table Schema:**
```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  text TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  user_avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable real-time (in Supabase Dashboard → Database → Replication)
-- Or via SQL:
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
```

**Row Level Security (RLS):**
```sql
-- Enable RLS
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read all messages
CREATE POLICY "Allow authenticated users to read messages" ON messages
  FOR SELECT USING (auth.role() = 'authenticated');

-- Allow authenticated users to insert their own messages
CREATE POLICY "Allow authenticated users to insert messages" ON messages
  FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' 
    AND auth.uid() = user_id
  );
```

**Note:** The `auth.users` table is automatically created by Supabase and contains user information from Google OAuth.

---

## Key Features to Implement

1. **Google OAuth Authentication**
   - Sign in with Google button
   - Handle authentication state
   - Store user session
   - Sign out functionality

2. **Real-time Messaging**
   - Messages appear instantly for all authenticated users
   - Use Supabase real-time subscriptions (PostgreSQL replication)
   - Show user avatar and name from Google account

3. **Message Display**
   - Different colors/styling for sent vs received (based on current user)
   - Show sender name and avatar
   - Show timestamp (optional)
   - Display user profile pictures from Google

4. **User Experience**
   - Smooth scrolling
   - Keyboard handling
   - Input validation
   - Loading states for authentication
   - Error handling for auth failures

---

## Next Steps After Minimal Version

- Multiple chat rooms/channels
- Image/file sharing
- Message status (sent, delivered, read)
- Typing indicators
- Message search
- Push notifications
- User profiles
- Direct messaging (1-on-1 chats)

---

## Quick Start Commands

### Setup Steps:
```bash
# 1. Create project at https://supabase.com
# 2. Configure Google OAuth (see Phase 1.3)
# 3. Get your project URL and anon key from Settings → API
# 4. Create 'messages' table (see Database Structure section)
# 5. Enable real-time replication for the table
# 6. Set up RLS policies (see Database Structure section)

# 7. Add Flutter dependency
flutter pub add supabase_flutter

# 8. Initialize in main.dart with your project URL and anon key
# 9. Run the app
flutter run
```

### Testing on multiple devices:
```bash
flutter run -d <device1>
flutter run -d <device2>
```

---

## Supabase Implementation Details

### Authentication Service Example
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // Sign in with Google
  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.guff_app://login-callback/',
    );
  }
  
  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
  
  // Get current user
  User? get currentUser => supabase.auth.currentUser;
  
  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
  
  // Check if user is authenticated
  bool get isAuthenticated => supabase.auth.currentUser != null;
}
```

### Chat Service Example
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // Send a message (uses authenticated user)
  Future<void> sendMessage(String text) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    
    await supabase.from('messages').insert({
      'text': text,
      'user_id': user.id,
      'user_name': user.userMetadata?['full_name'] ?? user.email ?? 'Unknown',
      'user_avatar_url': user.userMetadata?['avatar_url'],
    });
  }
  
  // Get messages stream (real-time via PostgreSQL replication)
  Stream<List<Message>> getMessages() {
    return supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false)
      .map((data) => data.map((json) => Message.fromJson(json)).toList());
  }
  
  // Get initial messages
  Future<List<Message>> getInitialMessages() async {
    final response = await supabase
      .from('messages')
      .select()
      .order('created_at', ascending: false)
      .limit(50);
    
    return (response as List)
      .map((json) => Message.fromJson(json))
      .toList();
  }
}
```

### Supabase Initialization in main.dart
```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  
  runApp(const MyApp());
}
```

### Google OAuth Configuration Steps

1. **In Google Cloud Console:**
   - Go to https://console.cloud.google.com
   - Create a new project (or select existing)
   - Enable Google+ API (or Google Identity API)
   - Go to Credentials → Create Credentials → OAuth 2.0 Client ID
   - Application type: Web application
   - Authorized redirect URIs: 
     - `https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback`
     - `io.supabase.guff_app://login-callback/` (for mobile)
   - Copy Client ID and Client Secret

2. **In Supabase Dashboard:**
   - Go to Authentication → Providers → Google
   - Enable Google provider
   - Paste Client ID and Client Secret
   - Save

3. **For Mobile Apps:**
   - Add URL scheme to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <activity>
       <intent-filter>
         <action android:name="android.intent.action.VIEW" />
         <category android:name="android.intent.category.DEFAULT" />
         <category android:name="android.intent.category.BROWSABLE" />
         <data android:scheme="io.supabase.guff_app" />
       </intent-filter>
     </activity>
     ```
   - Add URL scheme to `ios/Runner/Info.plist`:
     ```xml
     <key>CFBundleURLTypes</key>
     <array>
       <dict>
         <key>CFBundleURLSchemes</key>
         <array>
           <string>io.supabase.guff_app</string>
         </array>
       </dict>
     </array>
     ```


# Google OAuth Setup Verification Guide

Use this checklist to verify your Google OAuth setup is correct.

## ✅ Verification Checklist

### Part 1: Google Cloud Console

1. **Project Created**
   - [ ] Go to https://console.cloud.google.com
   - [ ] Your project is visible in the project dropdown
   - [ ] Project name: `guff-app` (or your chosen name)

2. **Google+ API Enabled**
   - [ ] Go to **APIs & Services** → **Library**
   - [ ] Search for "Google+ API" or "Google Identity"
   - [ ] Status shows "Enabled" ✅

3. **OAuth Consent Screen Configured**
   - [ ] Go to **APIs & Services** → **OAuth consent screen**
   - [ ] User type is set (External or Internal)
   - [ ] App name is filled: `Guff Chat App`
   - [ ] Support email is set
   - [ ] Status shows "In production" or "Testing"

4. **OAuth 2.0 Client ID Created**
   - [ ] Go to **APIs & Services** → **Credentials**
   - [ ] You see an OAuth 2.0 Client ID with type "Web application"
   - [ ] Name: `Guff Chat Web Client` (or your chosen name)
   - [ ] **Authorized redirect URIs** contains:
     - ✅ `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
   - [ ] **Client ID** is visible (starts with something like `123456789-abc...`)
   - [ ] **Client Secret** is visible (click "Show" to reveal)

### Part 2: Supabase Configuration

1. **Google Provider Enabled**
   - [ ] Go to https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/providers
   - [ ] Or: Dashboard → **Authentication** → **Providers**
   - [ ] Find **Google** in the list
   - [ ] Toggle shows **ON** ✅
   - [ ] **Client ID (for OAuth)** field is filled (matches Google Cloud Console)
   - [ ] **Client Secret (for OAuth)** field is filled (matches Google Cloud Console)
   - [ ] **Redirect URL** shows: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`

2. **Redirect URL Matches**
   - [ ] Supabase redirect URL: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
   - [ ] Google Cloud Console redirect URI: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
   - [ ] They match exactly ✅

### Part 3: Flutter App Configuration

1. **Android Manifest**
   - [ ] Open `android/app/src/main/AndroidManifest.xml`
   - [ ] Contains this inside `<activity>` tag:
     ```xml
     <intent-filter>
         <action android:name="android.intent.action.VIEW" />
         <category android:name="android.intent.category.DEFAULT" />
         <category android:name="android.intent.category.BROWSABLE" />
         <data android:scheme="io.supabase.guff_app" />
     </intent-filter>
     ```

2. **iOS Info.plist**
   - [ ] Open `ios/Runner/Info.plist`
   - [ ] Contains:
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

3. **AuthService Configuration**
   - [ ] Open `lib/services/auth_service.dart`
   - [ ] `signInWithGoogle()` method uses:
     ```dart
     redirectTo: 'io.supabase.guff_app://login-callback/'
     ```

4. **Supabase Initialization**
   - [ ] Open `lib/main.dart`
   - [ ] Supabase URL is set: `https://ypiidrjowcuxzfrqetkl.supabase.co`
   - [ ] Anon key is set (long string starting with `eyJ...`)

### Part 4: Database Security (After OAuth Works)

1. **RLS Policies Restored**
   - [ ] Run `supabase_restore_auth_policies.sql` in Supabase SQL Editor
   - [ ] Foreign key constraint restored
   - [ ] Authenticated-only policies active

---

## 🧪 Testing the Setup

### Test 1: Run the App

1. **Start the app:**
   ```bash
   flutter run
   ```

2. **Expected behavior:**
   - [ ] App shows **AuthScreen** (not ChatScreen)
   - [ ] You see "Sign in with Google" button
   - [ ] No errors in console

### Test 2: Google Sign-In Flow

1. **Click "Sign in with Google"**
   - [ ] Browser/WebView opens
   - [ ] Google sign-in page appears
   - [ ] You can select a Google account

2. **After selecting account:**
   - [ ] Google asks for permissions (if first time)
   - [ ] You can grant permissions
   - [ ] Browser redirects back to app

3. **After redirect:**
   - [ ] App automatically navigates to **ChatScreen**
   - [ ] You see the chat interface
   - [ ] No errors in console

### Test 3: Send a Message

1. **In ChatScreen:**
   - [ ] Type a message
   - [ ] Click send button
   - [ ] Message appears in the list
   - [ ] Message shows your Google account name (not "Test User")

### Test 4: Check User Info

1. **Verify authentication:**
   - [ ] Open Supabase Dashboard → **Authentication** → **Users**
   - [ ] You see a new user with your Google email
   - [ ] User metadata contains your Google profile info

---

## ❌ Common Issues & Solutions

### Issue: "Redirect URI mismatch"

**Symptoms:**
- Error when clicking "Sign in with Google"
- Browser shows redirect error

**Solution:**
- Check that redirect URI in Google Cloud Console exactly matches Supabase
- Must be: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
- No trailing slashes, no typos

### Issue: "Invalid client"

**Symptoms:**
- Error: "Invalid client ID" or "Invalid client secret"

**Solution:**
- Verify Client ID and Secret in Supabase match Google Cloud Console
- Make sure you copied the entire strings
- Check for extra spaces or line breaks

### Issue: "App doesn't redirect back"

**Symptoms:**
- Google sign-in works, but app doesn't open after authentication

**Solution:**
- Verify URL scheme in AndroidManifest.xml and Info.plist
- Must be: `io.supabase.guff_app`
- Check that `redirectTo` in AuthService matches: `io.supabase.guff_app://login-callback/`

### Issue: "Can't send messages after login"

**Symptoms:**
- Login works, but sending messages fails
- Error about foreign key or RLS policies

**Solution:**
- Run `supabase_restore_auth_policies.sql` to restore proper security
- Make sure you're authenticated (check Supabase Dashboard → Users)

---

## ✅ Quick Verification Commands

### Check Supabase Connection
```bash
flutter run
# Look for: "✅ Supabase initialized successfully!"
```

### Check Auth State
After running the app, check console for:
- `✅ Google sign-in initiated` (when clicking button)
- `✅ Signed out successfully` (if testing logout)

---

## 📝 Final Checklist

Before considering setup complete:

- [ ] Google Cloud Console: OAuth client created with correct redirect URI
- [ ] Supabase: Google provider enabled with Client ID and Secret
- [ ] Flutter: Android and iOS URL schemes configured
- [ ] Flutter: AuthService uses correct redirectTo
- [ ] App: Shows AuthScreen when not logged in
- [ ] App: Google sign-in button works
- [ ] App: Redirects to ChatScreen after login
- [ ] App: Can send messages with real user info
- [ ] Database: RLS policies restored (after testing)

---

## 🎉 Success Indicators

You'll know everything is working when:

1. ✅ Click "Sign in with Google" → Browser opens → Select account → App shows ChatScreen
2. ✅ Send a message → Message appears with your Google account name
3. ✅ Check Supabase Dashboard → Users → See your Google account
4. ✅ Messages table → New messages have your real user_id (not the hardcoded one)

---

## Need Help?

If something doesn't work:
1. Check the error message in the console
2. Verify each item in the checklist above
3. Check Supabase Dashboard → Authentication → Logs for OAuth errors
4. Check Google Cloud Console → APIs & Services → Credentials for any warnings


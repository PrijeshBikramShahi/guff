# Google OAuth Setup Guide

## Step 9: Configure Google OAuth

### Part 1: Google Cloud Console Setup

1. **Go to Google Cloud Console**
   - Visit: https://console.cloud.google.com
   - Sign in with your Google account

2. **Create a New Project (or select existing)**
   - Click the project dropdown at the top
   - Click "New Project"
   - Project name: `guff-app` (or any name)
   - Click "Create"
   - Wait for project creation (~30 seconds)

3. **Enable Google+ API**
   - In the left sidebar, go to **APIs & Services** → **Library**
   - Search for "Google+ API" or "Google Identity"
   - Click on it and click **Enable**

4. **Create OAuth 2.0 Credentials**
   - Go to **APIs & Services** → **Credentials**
   - Click **+ CREATE CREDENTIALS** → **OAuth client ID**
   - If prompted, configure OAuth consent screen first:
     - User Type: **External** (or Internal if using Google Workspace)
     - App name: `Guff Chat App`
     - User support email: (your email)
     - Developer contact: (your email)
     - Click **Save and Continue**
     - Scopes: Click **Save and Continue** (default is fine)
     - Test users: Click **Save and Continue** (skip for now)
     - Summary: Click **Back to Dashboard**

5. **Create OAuth Client ID**
   - Application type: **Web application**
   - Name: `Guff Chat Web Client`
   - Authorized redirect URIs: Click **+ ADD URI**
     - Add: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
     - ✅ This is your exact redirect URI (already using your project reference)
   - Click **CREATE**
   - **Copy the Client ID and Client Secret** (you'll need these!)

### Part 2: Supabase Configuration

1. **Go to Supabase Dashboard**
   - Open your project: https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl
   - (Replace with your project reference)

2. **Configure Google Provider**
   - Go to **Authentication** → **Providers**
   - Find **Google** in the list
   - Click to expand it
   - Toggle **Enable Google provider** to ON
   - Paste your **Client ID** from Google Cloud Console
   - Paste your **Client Secret** from Google Cloud Console
   - Click **Save**

3. **Verify Redirect URL**
   - In the Google provider settings, Supabase will show:
     - **Redirect URL**: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
   - ✅ This should match exactly what you added in Google Cloud Console!
   - **Where to find it in Supabase:**
     - Go to: https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/providers
     - Or: Dashboard → Authentication → Providers → Google
     - The redirect URL is shown in the provider settings

### Part 3: Mobile App Configuration (Flutter)

For mobile apps, we need to add URL schemes for OAuth callbacks.

#### Android Setup

1. Open `android/app/src/main/AndroidManifest.xml`
2. Find the `<activity>` tag with `android:name=".MainActivity"`
3. Add this inside the `<activity>` tag:
   ```xml
   <intent-filter>
     <action android:name="android.intent.action.VIEW" />
     <category android:name="android.intent.category.DEFAULT" />
     <category android:name="android.intent.category.BROWSABLE" />
     <data android:scheme="io.supabase.guff_app" />
   </intent-filter>
   ```

#### iOS Setup

1. Open `ios/Runner/Info.plist`
2. Add this before the closing `</dict>` tag:
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

### Part 4: Mobile App Configuration (Already Done ✅)

**Important:** The mobile URL scheme (`io.supabase.guff_app://`) is NOT added to Google Cloud Console!

**Why?**
- Google Cloud Console's OAuth 2.0 Client (Web application) only accepts `http://` or `https://` URLs
- The mobile URL scheme is only used in your Flutter app and manifest files (already configured)
- Supabase handles the OAuth flow: Google → Supabase → Your App (via mobile URL scheme)

**What you need in Google Cloud Console:**
- ✅ Only the web redirect URI: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
- ❌ Do NOT add: `io.supabase.guff_app://login-callback/` (this will cause an error)

**How it works:**
1. User clicks "Sign in with Google" in your app
2. App opens Google OAuth in browser
3. User authenticates with Google
4. Google redirects to Supabase: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
5. Supabase processes the OAuth and redirects to your app: `io.supabase.guff_app://login-callback/`
6. Your app receives the callback and completes authentication

The mobile URL scheme is already configured in:
- ✅ `android/app/src/main/AndroidManifest.xml` (already done)
- ✅ `ios/Runner/Info.plist` (already done)
- ✅ `lib/services/auth_service.dart` (redirectTo parameter)

---

## Verification Checklist

- [ ] Google Cloud project created
- [ ] Google+ API enabled
- [ ] OAuth consent screen configured
- [ ] OAuth 2.0 Client ID created (Web application)
- [ ] Supabase redirect URI added to Google Cloud Console
- [ ] Google provider enabled in Supabase
- [ ] Client ID and Secret added to Supabase
- [ ] Android URL scheme configured (if testing on Android)
- [ ] iOS URL scheme configured (if testing on iOS)
- [ ] Mobile redirect URI added to Google Cloud Console

---

## ✅ Verification

**After completing the setup, verify everything is correct:**
- See `VERIFY_OAUTH_SETUP.md` for a complete verification checklist
- Test the sign-in flow end-to-end
- Verify messages use your real Google account info

---

## Troubleshooting

**"Redirect URI mismatch" error:**
- Make sure the redirect URI in Google Cloud Console exactly matches Supabase's redirect URL
- Check for typos or extra spaces

**"Invalid client" error:**
- Verify Client ID and Secret are correct in Supabase
- Make sure you copied the entire strings

**Mobile OAuth not working:**
- Verify URL schemes are added correctly
- Check that mobile redirect URI is in Google Cloud Console
- Make sure you're using the correct package name

---

## Next Steps

Once Google OAuth is configured, we'll:
- Step 10: Create AuthService
- Step 11: Create AuthScreen
- Step 12: Connect authentication to chat


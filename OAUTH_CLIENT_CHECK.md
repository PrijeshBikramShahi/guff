# OAuth Client Configuration Check

## For Supabase + Flutter: You Only Need ONE OAuth Client

**Important:** For Supabase OAuth with Flutter mobile apps, you typically only need **ONE OAuth 2.0 Client** in Google Cloud Console:
- **Type:** Web application
- **Redirect URI:** `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`

You do NOT need separate iOS/Android OAuth clients. Supabase handles the redirect from web → mobile app.

## However, Check These Settings:

### 1. Verify OAuth Client in Google Cloud Console

Go to: https://console.cloud.google.com → APIs & Services → Credentials

**Check:**
- [ ] You have an OAuth 2.0 Client ID
- [ ] Type is "Web application" (not iOS or Android)
- [ ] Authorized redirect URIs contains:
  - ✅ `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`

### 2. Verify Supabase URL Configuration

Go to: https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/url-configuration

**Check:**
- [ ] **Site URL** is set (can be your Supabase project URL)
- [ ] **Redirect URLs** contains:
  - ✅ `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback` (for web)
  - ✅ `io.supabase.guff_app://login-callback` (for mobile deep link)

**This is important!** The mobile redirect URL must be added here for deep linking to work.

### 3. Verify Google Provider in Supabase

Go to: https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/providers

**Check:**
- [ ] Google provider is **Enabled**
- [ ] Client ID matches Google Cloud Console
- [ ] Client Secret matches Google Cloud Console
- [ ] Redirect URL shown is: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`

## The "localhost" Error

If you're seeing "localhost" in Safari, it usually means:
1. Supabase isn't configured to redirect to your mobile app
2. The mobile redirect URL isn't in Supabase's Redirect URLs list
3. The deep link isn't being recognized

## Solution: Add Mobile Redirect URL to Supabase

**This is likely the missing piece!**

1. Go to Supabase Dashboard → **Authentication** → **URL Configuration**
2. Under **Redirect URLs**, add:
   ```
   io.supabase.guff_app://login-callback
   ```
3. Click **Save**

This tells Supabase to redirect to your mobile app after OAuth completes.

## Alternative: Create Separate OAuth Clients (Not Recommended)

If the above doesn't work, you could create separate OAuth clients:

### iOS OAuth Client (if needed)
- Type: iOS
- Bundle ID: `com.example.guffApp` (from your Xcode project)
- But this is usually NOT needed with Supabase

### Android OAuth Client (if needed)
- Type: Android
- Package name: (check your AndroidManifest.xml)
- SHA-1 certificate fingerprint: (get from your keystore)
- But this is usually NOT needed with Supabase

**However, for Supabase, stick with the Web application client and add the mobile redirect URL to Supabase's URL Configuration instead.**


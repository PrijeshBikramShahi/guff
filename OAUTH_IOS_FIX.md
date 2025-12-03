# iOS OAuth Redirect Fix

## Issue: Safari shows "localhost" error after Google sign-in

This happens when Supabase tries to redirect back to your app but iOS isn't handling the deep link properly.

## Solution Applied

1. **Updated redirect URL** - Removed trailing slash:
   - Changed: `io.supabase.guff_app://login-callback/`
   - To: `io.supabase.guff_app://login-callback`

2. **Added deepLinkRedirectUrl** to Supabase initialization:
   - This helps Supabase know how to redirect back to your app on iOS

## Additional Steps if Still Not Working

### Option 1: Verify Info.plist

Make sure your `ios/Runner/Info.plist` has:
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

### Option 2: Clean and Rebuild

```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run
```

### Option 3: Check Supabase Site URL

1. Go to Supabase Dashboard → **Authentication** → **URL Configuration**
2. Make sure **Site URL** is set (can be your Supabase project URL)
3. Add to **Redirect URLs**: `io.supabase.guff_app://login-callback`

### Option 4: Use Web Redirect (Alternative)

If deep linking still doesn't work, you can temporarily use the web redirect:

```dart
await supabase.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: 'https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback',
);
```

Then manually check auth state after redirect. But deep linking is preferred.

## Testing

After applying the fix:
1. Stop the app completely
2. Rebuild: `flutter run`
3. Try sign-in again
4. Should redirect back to app instead of showing localhost error


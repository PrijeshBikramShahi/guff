# iOS OAuth "localhost" Error Fix

## Your Configuration is Correct ✅

Based on your screenshots:
- ✅ Supabase Redirect URLs: `io.supabase.guff_app://login-callback` is added
- ✅ Supabase Google Provider: Enabled with correct Client ID/Secret
- ✅ Google Cloud Console: Web application OAuth client configured correctly
- ✅ Info.plist: URL scheme configured
- ✅ AuthService: Using correct redirect URL

## The Issue

The "localhost" error happens when iOS can't properly handle the deep link callback after OAuth completes. This is often a timing or caching issue.

## Solutions to Try

### Solution 1: Clean Rebuild (Most Important)

After adding the redirect URL to Supabase, you MUST do a clean rebuild:

```bash
# Stop the app completely
# Then run:
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter pub get
flutter run
```

### Solution 2: Verify AppDelegate Handles URLs

I've updated `AppDelegate.swift` to properly handle URL callbacks. Make sure it's saved and rebuild.

### Solution 3: Test on Physical Device

iOS Simulator sometimes has issues with deep linking. Try on a physical iPhone if possible.

### Solution 4: Check Supabase Redirect URL Format

In Supabase Dashboard → Authentication → URL Configuration:
- Make sure the redirect URL is exactly: `io.supabase.guff_app://login-callback`
- No trailing slash
- No spaces
- Case-sensitive

### Solution 5: Wait for Supabase Settings to Propagate

Supabase settings can take a few minutes to propagate. Wait 2-3 minutes after adding the redirect URL, then try again.

### Solution 6: Check Console Logs

When you click "Sign in with Google", check the console for:
- `✅ Google sign-in initiated` - Should appear
- Any errors about URL handling
- Deep link callback messages

## Expected Flow

1. Click "Sign in with Google"
2. Safari opens (external browser)
3. Google sign-in page appears
4. Select account and authorize
5. Google redirects to Supabase
6. Supabase processes OAuth
7. Supabase redirects to: `io.supabase.guff_app://login-callback`
8. iOS opens your app via deep link
9. App receives callback and completes authentication
10. App navigates to ChatScreen

## If Still Not Working

1. **Double-check Supabase Redirect URL:**
   - Go to: Authentication → URL Configuration
   - Verify `io.supabase.guff_app://login-callback` is in the list
   - Try removing it and adding it again

2. **Check iOS Simulator vs Physical Device:**
   - Simulators sometimes have deep linking issues
   - Try on a physical device

3. **Verify URL Scheme in Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner target → Info tab
   - Check "URL Types" section
   - Should show: `io.supabase.guff_app`

4. **Check Supabase Logs:**
   - Go to Supabase Dashboard → Authentication → Logs
   - Look for OAuth errors or redirect issues

## Next Steps

1. Do a clean rebuild (Solution 1)
2. Test again
3. If still failing, check console logs for specific errors
4. Try on physical device if using simulator


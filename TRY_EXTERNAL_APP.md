# Try External Application Mode

## Current Issue

The "requested path is invalid" error occurs with in-app browser because:
- In-app browser can't properly trigger deep link redirects
- Supabase tries to redirect but the path format doesn't work in in-app browser

## Solution: Use External Application

I've changed the code to use `LaunchMode.externalApplication` with the deep link redirect. This should:
1. Open Safari (external browser)
2. Complete Google OAuth
3. Supabase redirects to deep link: `io.supabase.guff_app://login-callback`
4. iOS opens your app via deep link
5. App detects auth state change

## Test Steps

1. **Rebuild the app:**
   ```bash
   flutter clean
   flutter run
   ```

2. **Click "Sign in with Google"**
   - Should open Safari (not in-app browser)
   - Complete Google authentication
   - Should redirect back to app automatically

3. **If you still see "localhost" error:**
   - This means Supabase Site URL might still be wrong
   - Double-check Site URL is exactly: `https://ypiidrjowcuxzfrqetkl.supabase.co`
   - No trailing slash, no spaces

## Why This Should Work

- External browser (Safari) can properly handle the OAuth redirect
- Deep link redirect works better from external browser
- iOS can properly open the app via URL scheme

## If It Still Doesn't Work

Check Supabase Authentication Logs:
- Go to: Authentication → Logs
- Look for errors around the time you tried to sign in
- This will show the exact error from Supabase's side


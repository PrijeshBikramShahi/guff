# Fix "requested path is invalid" Error

## The Error

When using in-app browser, you're seeing: `{"error":"requested path is invalid"}`

This happens when Supabase tries to redirect but the path format is incorrect.

## Solution: Update Supabase Redirect URL

The redirect URL in Supabase must match exactly what you're using in code.

### Step 1: Check Supabase Redirect URLs

1. Go to: https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/url-configuration
2. Under **Redirect URLs**, make sure you have:
   - `io.supabase.guff_app://login-callback` (exactly this, no trailing slash)

### Step 2: Verify URL Format

The redirect URL should be:
- ✅ `io.supabase.guff_app://login-callback` (correct)
- ❌ `io.supabase.guff_app://login-callback/` (trailing slash - wrong)
- ❌ `io.supabase.guff_app://` (missing path - wrong)

### Step 3: Alternative - Use Web Redirect for In-App Browser

If the deep link still doesn't work with in-app browser, try using the web redirect URL:

```dart
redirectTo: 'https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback',
```

Then Supabase will redirect to the web page, and you can check auth state manually. The in-app browser will stay open, and after OAuth completes, the app should detect the auth state change.

### Step 4: Check Site URL

Also verify:
1. Go to: Authentication → URL Configuration
2. **Site URL** should be: `https://ypiidrjowcuxzfrqetkl.supabase.co`
3. NOT `http://localhost:3000` or any localhost

## Testing

1. Update Supabase Redirect URLs if needed
2. Rebuild: `flutter clean && flutter run`
3. Try sign-in again
4. Should work in in-app browser now


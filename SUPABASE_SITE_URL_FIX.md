# Fix Supabase Site URL for iOS OAuth

## The Problem

The "localhost" error on iOS often happens because Supabase's **Site URL** is set incorrectly or the deep link redirect isn't working properly.

## Solution 1: Check Supabase Site URL

1. Go to: https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/url-configuration
2. Check the **Site URL** field
3. It should be set to: `https://ypiidrjowcuxzfrqetkl.supabase.co`
   - NOT `http://localhost:3000` or any localhost URL
4. If it's wrong, update it and click **Save**

## Solution 2: Use Web Redirect (Temporary Workaround)

I've temporarily changed the `redirectTo` in AuthService to use the web URL instead of the deep link. This will:
- Open OAuth in Safari
- Redirect to Supabase web callback
- You'll need to manually check auth state after redirect

**To test this:**
1. The code is already updated
2. Rebuild: `flutter clean && flutter run`
3. Try sign-in
4. After Google auth, you'll be redirected to Supabase web page
5. Check if you're logged in (the app should detect auth state)

## Solution 3: Proper Deep Link Fix

Once web redirect works, we can fix deep linking properly. The issue might be:

1. **Site URL must be set correctly** (not localhost)
2. **Redirect URL in Supabase must match exactly** (no trailing slash)
3. **iOS needs proper URL scheme handling**

## Next Steps

1. **First, check Site URL in Supabase Dashboard**
2. **Test with web redirect** (already updated in code)
3. **If web redirect works**, we know OAuth is configured correctly
4. **Then we can fix deep linking** to redirect back to app automatically

## Alternative: Manual Auth Check

If web redirect works but deep link doesn't, we can:
- Use web redirect
- Add a manual "Check Auth Status" button
- Or poll auth state after OAuth completes

Let's first verify the Site URL and test with web redirect.


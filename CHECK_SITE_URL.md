# Critical: Check Supabase Site URL

## The "requested path is invalid" Error

This error almost always means the **Site URL** in Supabase is set incorrectly.

## Fix This First

1. **Go to Supabase Dashboard:**
   - https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/url-configuration

2. **Check the Site URL field:**
   - It MUST be: `https://ypiidrjowcuxzfrqetkl.supabase.co`
   - NOT `http://localhost:3000`
   - NOT empty
   - NOT any other URL

3. **If it's wrong:**
   - Update it to: `https://ypiidrjowcuxzfrqetkl.supabase.co`
   - Click **Save**

4. **Verify Redirect URLs:**
   - Should include: `io.supabase.guff_app://login-callback`
   - Can also include: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`

## Why This Matters

Supabase uses the Site URL to construct redirect paths. If it's set to localhost or wrong, it tries to redirect to an invalid path, causing the "requested path is invalid" error.

## After Fixing Site URL

1. Wait 1-2 minutes for changes to propagate
2. Rebuild the app: `flutter clean && flutter run`
3. Try sign-in again

This should fix the error!


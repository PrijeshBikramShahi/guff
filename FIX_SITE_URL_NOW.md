# Fix Site URL - URGENT

## The Problem

Your Site URL in Supabase is **incomplete**:
- Currently shows: `https://ypiidrjowcuxzfro` (truncated)
- Should be: `https://ypiidrjowcuxzfrqetkl.supabase.co`

This is causing the "requested path is invalid" error!

## Fix Steps

1. **In the Site URL field**, change it to the complete URL:
   ```
   https://ypiidrjowcuxzfrqetkl.supabase.co
   ```

2. **Click "Save changes"** button (green button on the right)

3. **Also add web callback to Redirect URLs** (optional but recommended):
   - Click "Add URL" button
   - Add: `https://ypiidrjowcuxzfrqetkl.supabase.co/auth/v1/callback`
   - This gives Supabase more flexibility

4. **Wait 1-2 minutes** for changes to propagate

5. **Rebuild and test:**
   ```bash
   flutter clean
   flutter run
   ```

## Why This Fixes It

The Site URL is used by Supabase to construct redirect paths. When it's incomplete or wrong, Supabase tries to redirect to an invalid path, causing the error.

After fixing the Site URL, the OAuth flow should work correctly!


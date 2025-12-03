# Fix "site url is improperly formatted" Error

## The Error

Supabase is returning: `"site url is improperly formatted"`

This means the Site URL in Supabase Dashboard has a formatting issue.

## Fix the Site URL

1. **Go to Supabase Dashboard:**
   - https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/url-configuration

2. **Check the Site URL field carefully:**
   - It should be EXACTLY: `https://ypiidrjowcuxzfrqetkl.supabase.co`
   - **NO trailing slash** (not `https://...supabase.co/`)
   - **NO spaces** before or after
   - **NO extra characters**
   - Must start with `https://`
   - Must end with `.supabase.co` (not `.com` or anything else)

3. **Common mistakes to avoid:**
   - ❌ `https://ypiidrjowcuxzfrqetkl.supabase.co/` (trailing slash)
   - ❌ `https://ypiidrjowcuxzfrqetkl.supabase.co ` (trailing space)
   - ❌ ` https://ypiidrjowcuxzfrqetkl.supabase.co` (leading space)
   - ❌ `http://ypiidrjowcuxzfrqetkl.supabase.co` (http instead of https)
   - ❌ `ypiidrjowcuxzfrqetkl.supabase.co` (missing https://)

4. **Correct format:**
   - ✅ `https://ypiidrjowcuxzfrqetkl.supabase.co`

5. **After fixing:**
   - Click "Save changes"
   - Wait 2-3 minutes for changes to propagate
   - Rebuild app: `flutter clean && flutter run`

## Double-Check

The Site URL must match your Supabase project URL exactly. You can verify it by:
- Going to: Settings → API
- Your Project URL should be: `https://ypiidrjowcuxzfrqetkl.supabase.co`
- Copy this EXACT value to the Site URL field


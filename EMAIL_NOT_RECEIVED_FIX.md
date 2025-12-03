# Email Not Received - Troubleshooting

## Quick Fix: Disable Email Confirmation (For Testing)

If you're not receiving emails, you can temporarily disable email confirmation:

1. **Go to Supabase Dashboard:**
   - https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/providers

2. **Click on "Email" provider**

3. **Scroll down and find "Confirm email" toggle**

4. **Turn it OFF** (disable email confirmation)

5. **Click "Save"**

6. **Now users can sign in immediately after sign up** (no email verification needed)

## Why Emails Might Not Be Sent

1. **Supabase Free Tier Limits:**
   - Free tier has limited email sending
   - Emails might be delayed or not sent

2. **Email in Spam Folder:**
   - Check your spam/junk folder
   - Look for emails from `noreply@mail.app.supabase.io` or similar

3. **Email Not Configured:**
   - Supabase uses default email service
   - For production, you should configure custom SMTP

4. **Check Supabase Logs:**
   - Go to: Authentication → Logs
   - Look for sign-up events
   - Check if email was sent

## Alternative: Check User Status

You can check if the user was created even without email confirmation:

1. Go to: Authentication → Users
2. Look for your email address
3. Check the "Email Confirmed" status

## For Production

When you're ready for production:
1. Configure custom SMTP in Supabase
2. Re-enable email confirmation
3. Use a proper email service (SendGrid, Mailgun, etc.)

## For Now: Disable Email Confirmation

The easiest solution for testing is to disable email confirmation so users can sign in immediately after sign up.


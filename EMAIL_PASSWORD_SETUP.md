# Email/Password Authentication Setup

## ✅ What's Done

I've updated the app to use email/password authentication instead of OAuth:

1. **AuthService** - Added `signUpWithEmail()` and `signInWithEmail()` methods
2. **AuthScreen** - Updated to show email/password form with sign up/sign in toggle
3. **ChatScreen** - Added sign out button in app bar
4. **ChatService** - Already uses authenticated user info (no changes needed)

## 🔧 Supabase Configuration

Email/password authentication is **enabled by default** in Supabase, but verify:

1. **Go to Supabase Dashboard:**
   - https://supabase.com/dashboard/project/ypiidrjowcuxzfrqetkl/auth/providers

2. **Check Email Provider:**
   - Should be **Enabled** ✅
   - "Confirm email" can be enabled or disabled (for testing, you can disable it)

3. **Email Templates (Optional):**
   - Go to: Authentication → Email Templates
   - You can customize the confirmation email if needed

## 🧪 Testing

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Sign Up:**
   - Enter an email and password (min 6 characters)
   - Click "Sign Up"
   - If email confirmation is enabled, check your email
   - If disabled, you'll be signed in immediately

3. **Sign In:**
   - Enter your email and password
   - Click "Sign In"
   - Should navigate to ChatScreen

4. **Send Messages:**
   - Messages will be sent with your email as the user name
   - User ID from Supabase auth is used

5. **Sign Out:**
   - Click the logout icon in the app bar
   - Should navigate back to AuthScreen

## 📝 Notes

- **Email confirmation:** If enabled in Supabase, users need to verify their email before signing in
- **Password requirements:** Minimum 6 characters (enforced in the form)
- **User name:** Currently uses email address as the display name
- **No OAuth redirect issues:** Email/password auth doesn't require redirect URLs!

## 🎯 Next Steps

The authentication is now working! You can:
- Test sending messages between different users
- Add user profile editing (change display name)
- Add password reset functionality
- Style the message bubbles better


# Image Sharing Setup Instructions

## ✅ Code is Ready!

All Flutter code for image sharing is implemented. Now you need to set up the database and storage.

---

## Step 1: Run SQL Script

1. **Go to Supabase Dashboard → SQL Editor**
2. **Open `add_image_sharing.sql`**
3. **Copy and paste the SQL**
4. **Click "Run"**

This adds:
- `message_type` column (text, image, file)
- `file_url` column
- `file_name` and `file_size` columns (optional)

---

## Step 2: Set Up Supabase Storage

### 2.1 Create Storage Bucket

1. **Go to Supabase Dashboard → Storage**
2. **Click "Create a new bucket"**
3. **Bucket name:** `chat-files`
4. **Public bucket:** ✅ Enable (or configure RLS policies)
5. **Click "Create bucket"**

### 2.2 Configure Bucket Policies (If Not Public)

If you didn't make it public, set up RLS policies:

1. **Go to Storage → Policies**
2. **Select `chat-files` bucket**
3. **Add policy:**
   - Policy name: "Allow authenticated uploads"
   - Allowed operation: INSERT
   - Policy definition: `auth.role() = 'authenticated'`
4. **Add policy:**
   - Policy name: "Allow authenticated reads"
   - Allowed operation: SELECT
   - Policy definition: `auth.role() = 'authenticated'`

---

## Step 3: Install Dependencies

Run in terminal:

```bash
flutter pub get
```

This installs `image_picker` package.

---

## Step 4: Test Image Sharing

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Start a conversation**

3. **Tap the image icon** (📷) next to the message input

4. **Select an image** from your gallery

5. **Image should upload and appear in chat!**

---

## Features

✅ **Image Picker** - Select images from gallery
✅ **Image Upload** - Uploads to Supabase Storage
✅ **Image Display** - Shows images in chat bubbles
✅ **Loading States** - Shows progress while uploading
✅ **Error Handling** - Shows error if upload fails

---

## How It Works

1. **User taps image icon** → Opens image picker
2. **User selects image** → Image path is captured
3. **Image uploaded** → To Supabase Storage bucket `chat-files`
4. **Message created** → With `message_type: 'image'` and `file_url`
5. **Image displayed** → In chat with loading/error states

---

## Troubleshooting

### "Bucket not found" error
- Make sure you created the `chat-files` bucket
- Check bucket name matches exactly

### "Permission denied" error
- Make bucket public, OR
- Set up RLS policies for authenticated users

### Image not displaying
- Check `file_url` in database
- Verify bucket is public or RLS allows reads
- Check network connection

### Upload fails
- Check file size (Supabase has limits)
- Verify storage quota not exceeded
- Check console for specific error

---

## Next Steps

After image sharing works, you can add:
- Image compression before upload
- Multiple image selection
- Image preview before sending
- File sharing (PDFs, documents, etc.)
- Image full-screen view on tap

---

## Storage Costs

Supabase free tier includes:
- 1 GB storage
- 2 GB bandwidth/month

For production, consider:
- Image compression
- CDN for faster delivery
- Storage limits per user

Good luck! 🚀


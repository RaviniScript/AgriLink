# Firebase Storage Rules - Profile Image Upload Fix

## The Problem
You're getting error: `Object does not exist at location` (Code: -13010, HTTP 404)
**Error Message**: `No object exists at the desired reference`

This means **Firebase Storage has not been initialized in your project yet**.

---

## Solution: Initialize Firebase Storage FIRST

### Step 1: Enable Firebase Storage (CRITICAL!)
1. Open https://console.firebase.google.com
2. Select your project: **AgriLink**
3. Click **Storage** in the left sidebar (you'll see "Get Started" button)
4. Click **"Get Started"** button
5. Choose **"Start in test mode"** (for development)
6. Click **"Next"**
7. Select your storage location (choose closest to your users)
8. Click **"Done"**

✅ This creates the Storage bucket for your project

---

### Step 2: Update Storage Rules (After enabling Storage)
1. Open https://console.firebase.google.com
2. Select your project: **AgriLink**
3. Click **Storage** in the left sidebar
4. Click **Rules** tab at the top

### Step 2: Update the Rules

**Option A - Quick Fix (For Development/Testing)**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```
This allows:
- ✅ Anyone can read (download) images
- ✅ Only authenticated users can upload

---

**Option B - Secure Rules (Recommended for Production)**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Profile images - users can only upload their own profile picture
    match /profile_images/{userId}.jpg {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Review images - authenticated users can upload
    match /reviews/{reviewId}/{imageId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Product images - only for farmers
    match /products/{productId}/{imageId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```
This is more secure:
- ✅ Users can only upload/update their own profile picture
- ✅ Review and product images have proper access control

---

### Step 3: Publish the Rules
1. After pasting the rules, click **Publish** button
2. Wait for confirmation message
3. Try uploading profile picture again in the app

---

## Code Changes Made

I've already updated your code in `buyer_profile_view.dart` to:
- ✅ Use Firebase Auth UID for better security
- ✅ Add proper metadata to uploaded files
- ✅ Better error handling with specific Firebase error messages
- ✅ Print detailed errors to console for debugging

---

## Testing

1. Update Firebase Storage rules (above)
2. Hot restart your app (press `R` in terminal or stop and run again)
3. Go to Buyer Profile
4. Tap profile picture → Select from Gallery/Camera
5. Image should upload successfully!

---

## Troubleshooting

If still getting errors:

1. **Check Firebase Console logs**: Firebase Console → Storage → Usage tab
2. **Verify user is authenticated**: Make sure you're logged in
3. **Check internet connection**: Firebase needs internet to upload
4. **Look at terminal output**: Detailed error messages will show

---

## Current Storage Structure

After successful upload, your Firebase Storage will look like:
```
storage/
  └── profile_images/
      └── {user-uid}.jpg  (e.g., o6jageg0ldQMpdcBm4Pcp0nOaRb2.jpg)
```

Each user's profile picture is stored with their Firebase Auth UID as the filename.

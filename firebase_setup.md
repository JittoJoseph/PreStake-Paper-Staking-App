# Firebase Setup Guide for PreStake

This guide provides detailed instructions for setting up Firebase in your PreStake project.

## Prerequisites
- Node.js and npm installed
- Flutter SDK installed
- Basic familiarity with terminal/command line

## Step-by-Step Setup

### 1. Install Required CLIs
```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### 2. Firebase Authentication
```bash
# Login to Firebase (this will open a browser window)
firebase login
```

### 3. Configure FlutterFire

Run the configuration command:
```bash
flutterfire configure
```

You'll be guided through several steps:

1. **Project Selection**
   - When prompted to select a Firebase project, choose "Create a new project"
   - Enter a project name (e.g., "prestake-dev" or "prestake-production")
   - Select your preferred geographical location
   - Wait for project creation to complete

2. **Platform Configuration**
   - FlutterFire will automatically detect your project platforms (iOS/Android)
   - Select the platforms you want to configure
   - The CLI will create necessary Firebase config files for each platform

### 4. Set Up Authentication

1. Go to your new project in the [Firebase Console](https://console.firebase.google.com)
2. Navigate to Authentication → Sign-in method
3. Enable Email/Password Authentication:
   - Click "Email/Password" in the provider list
   - Toggle the "Enable" switch
   - Click "Save"

### 5. Set Up Firestore Database

1. In Firebase Console, go to Firestore Database
2. Click "Create Database"
3. Choose Security Rules:
   - Select "Start in production mode"
   - Choose the closest region to your target users
   - Click "Enable"

4. Configure Firestore Rules:
   - Go to the "Rules" tab
   - Replace existing rules with:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```
   - Click "Publish"

## Verification

To verify your setup:

1. Check that `firebase_options.dart` was created in your project
2. Ensure Firebase packages are properly listed in `pubspec.yaml`
3. Verify you can access Firebase Console and see your new project
4. Try running the app to ensure there are no Firebase-related errors

## Common Issues and Solutions

### "flutterfire command not found"
- Ensure you've activated the FlutterFire CLI
- Try adding pub cache to your PATH

### Firebase Project Creation Fails
- Check your internet connection
- Ensure you have necessary permissions in Firebase
- Try creating the project manually in Firebase Console

### Authentication Not Working
- Verify Email/Password provider is enabled
- Check Firebase initialization in your code
- Ensure `firebase_options.dart` is properly imported

## Need Help?

If you encounter any issues:
- Check [Firebase Flutter documentation](https://firebase.flutter.dev/docs/overview/)
- Visit [FlutterFire GitHub issues](https://github.com/firebase/flutterfire/issues)
- Reach out to project maintainers
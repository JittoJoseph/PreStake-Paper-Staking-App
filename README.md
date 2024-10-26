# PreStake

<img src="assets/icon/app_icon.png" alt="PreStake Logo" width="150"/>

PreStake is a Flutter-based mobile application that simulates NEAR Protocol staking operations. It provides a risk-free environment for users to learn and experiment with NEAR staking strategies through paper staking.

## Features

### Authentication
- Simple and intuitive sign-in/sign-up interface
- Firebase Authentication integration
- Persistent login state management

### Dashboard
- Real-time portfolio overview
  - Total portfolio value
  - Staked NEAR balance
  - Available NEAR balance
  - Accumulated rewards
- Live NEAR/USD exchange rate
- Detailed visualization of active stakes
  - Individual stake amounts
  - Stake initiation dates
  - Real-time reward calculations
  - Current stake status

### Core Functions
- Simulate NEAR token staking
- Manage unstaking operations
- Automatic reward calculations based on:
  - Stake duration
  - Current average APY
- User profile management
- Complete transaction history

### Data Management
- Secure data storage with Firebase Firestore
- Real-time transaction tracking
- Separate balance management for:
  - Staked tokens
  - Available tokens
  - Accumulated rewards

## Project Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase CLI
- Git
- A Firebase project

### Installation Steps

1. Clone the repository
```bash
git clone https://github.com/yourusername/prestake.git
cd prestake
```

2. Install dependencies
```bash
flutter pub get
```

3. Firebase Setup
```bash
# Install Firebase CLI if you haven't already
npm install -g firebase-tools

# Login to Firebase
firebase login

# Configure Firebase for Flutter
flutterfire configure
```

4. Set up Firestore Rules
In your Firebase Console:
1. Navigate to Firestore Database
2. Go to Rules tab
3. Replace existing rules with:
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

5. Configure Firebase Project
- Create a new project in Firebase Console
- Enable Email/Password authentication:
  1. Go to Authentication → Sign-in method
  2. Enable Email/Password provider
- Enable Firestore Database:
  1. Create a new database in production mode
  2. Choose the closest region to your target users

6. Run the app
```bash
flutter run
```


## License

This project is licensed under Apache License 2.0 - see the [LICENSE](LICENSE) file for details.



## Contact

Jitto Joseph - [@JittoJoseph50](https://x.com/JittoJoseph50)

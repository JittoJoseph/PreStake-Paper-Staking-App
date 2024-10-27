# PreStake

<img src="assets/icon/app_icon.png" alt="PreStake Logo" width="150"/>



PreStake is a Flutter-based mobile application that simulates NEAR Protocol staking operations. It provides a risk-free environment for users to learn and experiment with NEAR staking strategies through paper trading.

## Demo

You can try the Android version of the app by downloading it from [GitHub Releases](https://github.com/JittoJoseph/PreStake-Paper-Staking-App/releases/tag/stable).
you can also watch the demo video from [youtube](https://youtu.be/zHXnevURYHk)

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

## Technical Stack

- **Frontend Framework**: Flutter
- **Backend Services**: Firebase
  - Authentication: Firebase Auth
  - Database: Cloud Firestore
  - Analytics: Firebase Analytics
- **State Management**: Provider
- **API Integration**: Meta pool sdk  Analytics API endpoints
- **Development Tools**:
  - Android Studio
  - VS Code
  - Flutter DevTools
- **Version Control**: Git

## Project Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase CLI
- Git

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
- ### Follow the detailed Firebase setup instructions in [firebase_setup.md](firebase_setup.md)

4. Run the app
```bash
flutter run
```

## License

This project is licensed under Apache License 2.0 - see the [LICENSE](LICENSE) file for details.



## Contact

Jitto Joseph - [@JittoJoseph50](https://x.com/JittoJoseph50)

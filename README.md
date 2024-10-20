# StakeRewards - Meta Pool Staking Tracker

## 🎯 Overview

StakeRewards is a mobile application built as a project for the [REDACTED] Hackathon that enables users to track their NEAR cryptocurrency staking rewards in real-time. Whether you're an experienced staker or just getting started, StakeRewards provides an intuitive interface to monitor your staking activities and receive timely notifications about your rewards.

## ✨ Key Features

- 🔐 Secure user authentication (Email/Password)
- 👛 Wallet connection and management
- 📊 Real-time staking rewards tracking
- 🔔 Push notifications for reward milestones
- 📈 Interactive dashboard for visualizing staking activities
- 🎮 Simulation mode for testing strategies
- 🌓 Elegant dark mode UI

## 🛠 Technical Stack

- **Frontend Framework**: Flutter (Dart)
- **Backend Services**: Firebase
  - Authentication
  - Cloud Firestore
  - Cloud Messaging
- **Blockchain Integration**: Meta Pool SDK
- **State Management**: Provider

## 🎨 Design

The app features a modern, dark-themed design with a carefully chosen color palette:
- Primary Color: `rgb(206, 255, 26)`
- Background Color: `rgb(13, 43, 51)`
- Accent Color: `rgb(26, 255, 206)`


## 🚀 Getting Started

### Prerequisites

- Flutter (latest version)
- Dart SDK
- Firebase account
- Meta Pool account
- Android Studio

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/stake-rewards.git
cd stake-rewards
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Create a new Firebase project
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Place them in their respective directories

4. Run the app
```bash
flutter run
```

## 📖 Usage

1. **Sign Up/Login**: Create an account or log in using email/password
2. **Choose Mode**: Select between real wallet connection or simulation mode
3. **Connect Wallet**: If using real mode, connect your NEAR wallet
4. **Monitor Stakes**: View your staking activities and rewards
5. **Receive Notifications**: Get alerts for important staking events

## 🔒 Security

- All sensitive data is encrypted
- Authentication handled securely through Firebase
- Regular security audits conducted

## 📄 License

This project is Licensed under the Apache License - see the [LICENSE](LICENSE) file for details.

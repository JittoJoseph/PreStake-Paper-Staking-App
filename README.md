# PreStake

<img src="assets/icon/app_icon.png" alt="PreStake Logo" width="150"/>



PreStake is a Flutter-based mobile application that simulates NEAR Protocol staking operations. It provides a risk-free environment for users to learn and experiment with NEAR staking strategies through paper trading.

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

## Contributing

We welcome contributions to PreStake! Please feel free to submit issues and pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under Apache License 2.0 - see the [LICENSE](LICENSE) file for details.



## Contact

Jitto Joseph - [@JittoJoseph50](https://x.com/JittoJoseph50)

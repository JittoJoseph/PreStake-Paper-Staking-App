import 'package:flutter/material.dart';
import 'pages/authentication.dart';
import 'pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Color scheme constants
class AppColors {
  static const primaryColor = Color.fromRGBO(206, 255, 26, 1); // Neon Green
  static const backgroundColor = Color.fromRGBO(13, 43, 51, 1); // Dark Teal
  static const accentColor = Color.fromRGBO(26, 255, 206, 1); // Cyan

  // Add additional colors as needed
  static const textColorPrimary = Colors.white;
  static const textColorSecondary = Colors.white70;
  static const primaryColourDim = Color.fromRGBO(205, 255, 26, 0.849);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StakeRewardsApp());
}

class StakeRewardsApp extends StatelessWidget {
  const StakeRewardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEAR Paper Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.textColorPrimary,
              displayColor: AppColors.textColorPrimary,
            ),
        // Additional theme settings
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: AppColors.textColorSecondary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.accentColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return const DashboardPage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

// Keep your existing LoginScreen class from the previous main.dart
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundColor,
              AppColors.backgroundColor.withOpacity(0.8)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.account_balance_wallet,
                          size: 80, color: AppColors.primaryColor),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome to Paper Wallet',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 48),
                      _buildButton(
                        label: 'Sign In',
                        primary: true,
                        backgroundColor: AppColors.primaryColor,
                        textColor: AppColors.backgroundColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildButton(
                        label: 'Sign Up',
                        primary: false,
                        backgroundColor: AppColors.accentColor,
                        textColor: AppColors.backgroundColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '© 2024 Jitto Joseph',
                  style: TextStyle(
                      color: AppColors.primaryColor.withOpacity(0.7),
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool primary,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? backgroundColor : Colors.transparent,
        foregroundColor: primary ? textColor : backgroundColor,
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: primary ? BorderSide.none : BorderSide(color: backgroundColor),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'pages/staketypes.dart';

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
      title: 'StakeRewards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(206, 255, 26, 1),
        scaffoldBackgroundColor: const Color.fromRGBO(13, 43, 51, 1),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // If sign in succeeds, navigate to StakeTypesPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StakeTypesPage()),
      );
    } catch (e) {
      // Handle any errors here
      print('Error signing in with Google: $e');
      // You might want to show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    const accentColor = Color.fromRGBO(26, 255, 206, 1);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
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
                      Icon(Icons.account_balance_wallet,
                          size: 80, color: primaryColor),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to StakeRewards',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 48),
                      _buildButton(
                        label: 'Continue with Google',
                        primary: true,
                        backgroundColor: primaryColor,
                        textColor: backgroundColor,
                        onPressed: () => signInWithGoogle(context),
                      ),
                      const SizedBox(height: 20),
                      _buildButton(
                        label: 'Sign In',
                        primary: false,
                        backgroundColor: accentColor,
                        textColor: backgroundColor,
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
                        backgroundColor: Colors.white,
                        textColor: backgroundColor,
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
                      color: primaryColor.withOpacity(0.7), fontSize: 12),
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

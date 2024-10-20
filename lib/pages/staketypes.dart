import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StakeTypesPage extends StatelessWidget {
  const StakeTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(206, 255, 26, 1);
    const backgroundColor = Color.fromRGBO(13, 43, 51, 1);
    const accentColor = Color.fromRGBO(26, 255, 206, 1);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Your Staking Mode',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildOptionButton(
                    context,
                    'Connect Real Wallet',
                    Icons.link,
                    primaryColor,
                    backgroundColor,
                    () => _navigateToDashboard(context, true),
                  ),
                  const SizedBox(height: 20),
                  _buildOptionButton(
                    context,
                    'Simulate Stakes',
                    Icons.science,
                    accentColor,
                    backgroundColor,
                    () => _navigateToDashboard(context, false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String label, IconData icon,
      Color color, Color textColor, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: textColor),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: color,
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: onPressed,
    );
  }

  void _navigateToDashboard(BuildContext context, bool isRealStake) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRealStake', isRealStake);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => DashboardPage(isRealStake: isRealStake),
      ),
    );
  }
}

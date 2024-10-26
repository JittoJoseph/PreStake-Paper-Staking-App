import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Import AppColors from main.dart since they're used in the code
import '../main.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;

    // Instead of pushing to LoginScreen, pop until we reach the root
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<Map<String, dynamic>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData.data() ?? {};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    // Use AppColors instead of hardcoded colors
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account',
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = snapshot.data ?? {};
            final user = FirebaseAuth.instance.currentUser;
            final createdAt = userData['createdAt'] as Timestamp?;
            final joinDate = createdAt?.toDate() ?? DateTime.now();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(
                          Icons.account_circle,
                          size: 80,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildAccountDetails(
                      AppColors.primaryColor,
                      AppColors.accentColor,
                      userData['name'] ?? 'N/A',
                      user?.email ?? 'N/A',
                      DateFormat('MMMM dd, yyyy').format(joinDate),
                      userData['availableNEARBalance'] ?? 0,
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(
                        AppColors.primaryColor, AppColors.accentColor),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.accentColor,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side:
                                const BorderSide(color: AppColors.accentColor),
                          ),
                        ),
                        onPressed: () => _logout(context),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccountDetails(Color primaryColor, Color accentColor,
      String name, String email, String joinDate, num vNearBalance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Details',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Name', name, accentColor),
        _buildDetailRow('Email', email, accentColor),
        _buildDetailRow('Joined', joinDate, accentColor),
        _buildDetailRow(
            'NEAR Balance', vNearBalance.toStringAsFixed(2), accentColor),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            value,
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(Color primaryColor, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsToggle('Push Notifications', true, accentColor),
        _buildSettingsToggle('Email Notifications', false, accentColor),
        _buildSettingsToggle('Two-Factor Authentication', true, accentColor),
        _buildSettingsToggle('Dark Mode', true, accentColor),
      ],
    );
  }

  Widget _buildSettingsToggle(String label, bool value, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              // TODO: Implement settings change logic
            },
            activeColor: accentColor,
            activeTrackColor: accentColor.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isRealStake');
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
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
    const primaryColor = Color.fromRGBO(206, 255, 26, 1);
    const backgroundColor = Color.fromRGBO(13, 43, 51, 1);
    const accentColor = Color.fromRGBO(26, 255, 206, 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
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
                        backgroundColor: primaryColor,
                        child: Icon(
                          Icons.account_circle,
                          size: 80,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildAccountDetails(
                      primaryColor,
                      accentColor,
                      userData['displayName'] ?? 'N/A',
                      user?.email ?? 'N/A',
                      DateFormat('MMMM dd, yyyy').format(joinDate),
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(primaryColor, accentColor),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: accentColor,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(color: accentColor),
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
      String name, String email, String joinDate) {
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

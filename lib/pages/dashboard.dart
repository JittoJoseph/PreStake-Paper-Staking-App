import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'account.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml for number formatting

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(206, 255, 26, 1);
    const backgroundColor = Color.fromRGBO(13, 43, 51, 1);
    const accentColor = Color.fromRGBO(26, 255, 206, 1);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search validators',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: primaryColor),
                  fillColor: backgroundColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.account_circle,
                    color: primaryColor, size: 38),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountPage()),
                  );
                },
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
            ),
          ),
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: () async {
              // Implement refresh logic
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Quick Stats Section
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickStatCard(
                        'Total Staked',
                        '125,000 NEAR',
                        Icons.account_balance,
                        primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickStatCard(
                        'Total Rewards',
                        '1,250 NEAR',
                        Icons.stars,
                        accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickStatCard(
                        'Current APY',
                        '12.5%',
                        Icons.trending_up,
                        primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickStatCard(
                        'Daily Earnings',
                        '42 NEAR',
                        Icons.calendar_today,
                        accentColor,
                      ),
                    ),
                  ],
                ),

                // Charts Section
                const SizedBox(height: 24),
                _buildSectionTitle('Rewards History', primaryColor),
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Text(
                      'Rewards Chart Will Go Here',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

                // Stakes List Section
                const SizedBox(height: 24),
                _buildSectionTitle('Active Stakes', primaryColor),
                _buildStakeCard(
                  'Meta Pool Validator',
                  '50,000 NEAR',
                  '13.2%',
                  'Active',
                  primaryColor,
                  accentColor,
                ),
                const SizedBox(height: 12),
                _buildStakeCard(
                  'Near Foundation',
                  '75,000 NEAR',
                  '11.8%',
                  'Active',
                  primaryColor,
                  accentColor,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: backgroundColor),
          onPressed: () {
            // Implement new stake action
          },
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: color, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStakeCard(String validator, String amount, String apy,
      String status, Color primaryColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                validator,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Staked Amount',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    amount,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'APY',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    apy,
                    style: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Implement claim rewards action
                },
                child: Text(
                  'Claim Rewards',
                  style: TextStyle(color: accentColor),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // Implement manage stake action
                },
                child: const Text(
                  'Manage',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

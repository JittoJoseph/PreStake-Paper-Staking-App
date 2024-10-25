import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> stakes = [];

  double stNearNearExchangeRate = 1.0;
  double stNearUsdPrice = 1.0;
  double apy = 0.12; // Fixed APY of 12%
  double nearUsdPrice = 1.0; // Added NEAR to USD exchange rate

  Future<void> _fetchExchangeRates() async {
    try {
      final nearResponse = await http.get(Uri.parse(
          'https://validators.narwallets.com/metrics/price/stnear-near'));
      final usdResponse = await http.get(Uri.parse(
          'https://validators.narwallets.com/metrics/price/stnear-usd'));

      if (nearResponse.statusCode == 200 && usdResponse.statusCode == 200) {
        // Parse the response body differently based on its type
        dynamic nearData = jsonDecode(nearResponse.body);
        dynamic usdData = jsonDecode(usdResponse.body);

        setState(() {
          // Convert the data to double, handling different possible formats
          stNearNearExchangeRate = _parseToDouble(nearData);
          stNearUsdPrice = _parseToDouble(usdData);
          nearUsdPrice =
              stNearUsdPrice / stNearNearExchangeRate; // Update nearUsdPrice
        });
      } else {
        // Handle error - show a snackbar or log the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error fetching exchange rates: ${nearResponse.statusCode} ${usdResponse.statusCode}')),
        );
        print('Error fetching exchange rates');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching exchange rates: $e')));
      print('Error fetching exchange rates: $e');
    }
  }

// Helper function to parse different data types to double
  double _parseToDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.parse(value);
    } else {
      throw FormatException('Unable to parse value to double: $value');
    }
  }

  Map<String, dynamic>? userData;
  bool isLoading = true;

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDataSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          userData = userDataSnapshot.data();
          isLoading = false;
        });
      } else {
        // Handle the case where the user is not logged in
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle errors appropriately
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user data: $e')));
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(206, 255, 26, 1);
    const backgroundColor = Color.fromRGBO(13, 43, 51, 1);
    const accentColor = Color.fromRGBO(26, 255, 206, 1);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text('User data not found')),
      );
    }

    final totalStakedNear = userData!['stakedNEARBalance'] as num? ?? 0;
    final totalRewardsEarned = userData!['totalRewardsEarned'] as num? ?? 0;
    final availableNear = userData!['availableNEARBalance'] as num? ?? 0;
    // Updated Calculation for totalPortfolioValue
    final totalPortfolioValue = totalStakedNear.toDouble() * stNearUsdPrice +
        (availableNear + totalRewardsEarned).toDouble() * nearUsdPrice;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: primaryColor),
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
                  MaterialPageRoute(builder: (context) => const AccountPage()),
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
            await _fetchExchangeRates();
            await _fetchUserData();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Quick Stats Section
              Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      'Total Portfolio Value',
                      '\$${totalPortfolioValue.toStringAsFixed(2)}',
                      Icons.account_balance_wallet,
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickStatCard(
                      'Total Staked NEAR',
                      '${NumberFormat.compact().format(totalStakedNear)} NEAR',
                      Icons.stacked_line_chart,
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
                      'Rewards Earned',
                      '${NumberFormat.compact().format(totalRewardsEarned)} NEAR',
                      Icons.currency_exchange,
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickStatCard(
                      'Available NEAR',
                      '${NumberFormat.compact().format(availableNear)} NEAR',
                      Icons.account_balance_wallet,
                      accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildExchangeRateCard('1 NEAR =', nearUsdPrice, accentColor),

              // Stakes List Section
              const SizedBox(height: 24),
              _buildSectionTitle('Active Stakes', primaryColor),
              ...stakes.map((stake) => _buildStakeCard(
                    stake['validator'],
                    stake['amount'],
                    stake['apy'].toDouble(),
                    stake['status'],
                    primaryColor,
                    accentColor,
                  )),
            ],
          ),
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

  Widget _buildStakeCard(String validator, num amount, double apy,
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
                    NumberFormat.compact().format(amount),
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
                    apy.toStringAsFixed(2),
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

  double _calculateTotalRewards() {
    return stakes.fold<double>(0.0, (sum, stake) {
      final daysStaked =
          DateTime.now().difference(stake['startDate'] as DateTime).inDays;
      return sum +
          ((stake['amount'] as num).toDouble() *
              (stake['apy'] as num).toDouble() /
              100 /
              365 *
              daysStaked);
    });
  }

  double _calculateAverageAPY() {
    if (stakes.isEmpty) return 0;
    return stakes.fold<double>(
            0.0, (sum, stake) => sum + (stake['apy'] as num).toDouble()) /
        stakes.length;
  }

  double _calculateDailyEarnings() {
    return stakes.fold<double>(
        0.0,
        (sum, stake) =>
            sum +
            ((stake['amount'] as num).toDouble() *
                (stake['apy'] as num).toDouble() /
                100 /
                365));
  }

  Widget _buildExchangeRateCard(String title, double rate, Color color) {
    return Card(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontSize: 16),
            ),
            Text(
              '\$${rate.toStringAsFixed(4)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

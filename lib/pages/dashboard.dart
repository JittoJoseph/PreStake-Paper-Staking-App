import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stakingnotify/main.dart';
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
  List<dynamic> stakes = [];
  final amountController = TextEditingController();
  bool showAllStakes = false;
  final stakeAmountController = TextEditingController();

  double stNearNearExchangeRate = 1.0;
  double stNearUsdPrice = 1.0;
  double apy = 0.12;
  double nearUsdPrice = 1.0;

  Future<void> _fetchExchangeRates() async {
    try {
      final nearResponse = await http.get(Uri.parse(
          'https://validators.narwallets.com/metrics/price/stnear-near'));
      final usdResponse = await http.get(Uri.parse(
          'https://validators.narwallets.com/metrics/price/stnear-usd'));

      if (nearResponse.statusCode == 200 && usdResponse.statusCode == 200) {
        dynamic nearData = jsonDecode(nearResponse.body);
        dynamic usdData = jsonDecode(usdResponse.body);

        setState(() {
          stNearNearExchangeRate = _parseToDouble(nearData);
          stNearUsdPrice = _parseToDouble(usdData);
          nearUsdPrice = stNearUsdPrice / stNearNearExchangeRate;
        });
      } else {
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
        _updateStakesList(); // Make sure this is being called
        print("fetchUserData completed. userData: $userData"); // Debug print
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error in fetchUserData: $e"); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user data: $e')));
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
  void dispose() {
    amountController.dispose();
    stakeAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    final totalPortfolioValue = totalStakedNear.toDouble() * stNearUsdPrice +
        (availableNear + totalRewardsEarned).toDouble() * nearUsdPrice;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle,
                  color: AppColors.primaryColor, size: 38),
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
            colors: [
              AppColors.backgroundColor,
              AppColors.backgroundColor.withOpacity(0.8)
            ],
          ),
        ),
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            await _fetchExchangeRates();
            await _fetchUserData();
          },
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickStatCard(
                            'Total Portfolio Value',
                            '\$${totalPortfolioValue.toStringAsFixed(2)}',
                            Icons.account_balance_wallet,
                            AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickStatCard(
                            'Total Staked NEAR',
                            '${NumberFormat.compact().format(totalStakedNear)} NEAR',
                            Icons.stacked_line_chart,
                            AppColors.accentColor,
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
                            AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickStatCard(
                            'Available NEAR',
                            '${NumberFormat.compact().format(availableNear)} NEAR',
                            Icons.account_balance_wallet,
                            AppColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildExchangeRateCard(
                        '1 NEAR =', nearUsdPrice, AppColors.accentColor),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Active Stakes', AppColors.primaryColor),
                    ..._buildStakesList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.backgroundColor,
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _showStakeDialog(context),
                      child: const Text('Stake'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
                        foregroundColor: AppColors.backgroundColor,
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {}, // Implement unstake logic later
                      child: const Text('Unstake'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStakesList() {
    print(
        "Building stakes list. Stakes length: ${stakes.length}"); // Debug print
    if (stakes.isEmpty) {
      return [
        const Center(child: Text('No active stakes')),
      ];
    }

    return stakes.map((stake) {
      print("Processing stake: $stake"); // Debug print
      if (stake['amount'] == null || stake['apy'] == null) {
        return const SizedBox.shrink();
      }
      return _buildStakeCard(
        '', // empty string since we don't use validator
        stake['amount'],
        stake['apy'].toDouble(),
        'Active',
        AppColors.primaryColor,
        AppColors.accentColor,
      );
    }).toList();
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
      dynamic status, Color primaryColor, Color accentColor) {
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
                '${NumberFormat.compact().format(amount)} NEAR',
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
                  'Active',
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
                    'stNEAR',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    NumberFormat.compact()
                        .format(amount * stNearNearExchangeRate),
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
                    '${apy.toStringAsFixed(2)}%',
                    style: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ],
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

  Future<void> _stakeNEAR() async {
    final amountToStake = double.tryParse(stakeAmountController.text) ?? 0.0;

    if (amountToStake <= 0 ||
        amountToStake > (userData?['availableNEARBalance']?.toDouble() ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid stake amount')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Create the simplified stake transaction
        final stakeTransaction = {
          'amountNear': amountToStake,
          'amountStNear':
              amountToStake * stNearNearExchangeRate, // Convert NEAR to stNEAR
          'timestamp': DateTime.now(),
          'type': 'stake',
          'rewards': 0.0, // Initial rewards are 0
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'availableNEARBalance':
              (userData!['availableNEARBalance'] as num).toDouble() -
                  amountToStake,
          'stakedNEARBalance':
              (userData!['stakedNEARBalance'] as num).toDouble() +
                  amountToStake,
          'transactions': FieldValue.arrayUnion([stakeTransaction]),
        });

        setState(() {
          _fetchUserData();
          Navigator.of(context).pop();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$amountToStake NEAR staked successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error staking NEAR: $e')),
        );
      }
    }
  }

  void _showStakeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: const Text('Stake NEAR',
              style: TextStyle(color: AppColors.primaryColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Amount to stake:',
                  style: TextStyle(color: AppColors.textColorPrimary)),
              TextField(
                controller: stakeAmountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textColorPrimary),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle:
                      const TextStyle(color: AppColors.textColorSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.accentColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              Text('Available NEAR: ${userData?['availableNEARBalance'] ?? 0}',
                  style: const TextStyle(color: AppColors.textColorPrimary)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel',
                        style: TextStyle(color: AppColors.accentColor)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _stakeNEAR,
                    child: const Text('Stake'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateStakesList() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        final transactions =
            value.data()?['transactions'] as List<dynamic>? ?? [];
        print("Raw transactions from Firestore: $transactions");

        final stakeTransactions = transactions
            .where((transaction) => transaction['type'] == 'stake')
            .map((transaction) => {
                  'amount': transaction['amountNear'] ?? 0.0,
                  'apy': apy,
                })
            .toList();
        print("Processed stake transactions: $stakeTransactions");

        setState(() {
          stakes = stakeTransactions;
          print("Stakes array after setState: $stakes");
        });
      });
    }
  }
}

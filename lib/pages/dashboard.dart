import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'account.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> stakes = [
    {
      'validator': 'Meta Pool Validator',
      'amount': 50000,
      'apy': 13.2,
      'status': 'Active',
      'startDate': DateTime.now().subtract(const Duration(days: 30)),
    },
    {
      'validator': 'Near Foundation',
      'amount': 75000,
      'apy': 11.8,
      'status': 'Active',
      'startDate': DateTime.now().subtract(const Duration(days: 60)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(206, 255, 26, 1);
    const backgroundColor = Color.fromRGBO(13, 43, 51, 1);
    const accentColor = Color.fromRGBO(26, 255, 206, 1);

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
                      '${NumberFormat.compact().format(stakes.fold(0.0, (sum, stake) => sum + (stake['amount'] as num).toDouble()))} NEAR',
                      Icons.account_balance,
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickStatCard(
                      'Total Rewards',
                      '${NumberFormat.compact().format(_calculateTotalRewards())} NEAR',
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
                      'Average APY',
                      '${_calculateAverageAPY().toStringAsFixed(2)}%',
                      Icons.trending_up,
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickStatCard(
                      'Daily Earnings',
                      '${_calculateDailyEarnings().toStringAsFixed(2)} NEAR',
                      Icons.calendar_today,
                      accentColor,
                    ),
                  ),
                ],
              ),

              // Stakes List Section
              const SizedBox(height: 24),
              _buildSectionTitle('Active Stakes', primaryColor),
              ...stakes.map((stake) => _buildStakeCard(
                    stake['validator'],
                    '${NumberFormat.compact().format(stake['amount'])} NEAR',
                    '${stake['apy']}%',
                    stake['status'],
                    primaryColor,
                    accentColor,
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _showAddStakeDialog,
        child: const Icon(Icons.add, color: backgroundColor),
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

  double _calculateTotalRewards() {
    return stakes.fold(0.0, (sum, stake) {
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
    return stakes.fold(
            0.0, (sum, stake) => sum + (stake['apy'] as num).toDouble()) /
        stakes.length;
  }

  double _calculateDailyEarnings() {
    return stakes.fold(
        0.0,
        (sum, stake) =>
            sum +
            ((stake['amount'] as num).toDouble() *
                (stake['apy'] as num).toDouble() /
                100 /
                365));
  }

  void _showAddStakeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String validator = '';
        double amount = 0;
        double apy = 0;
        DateTime startDate = DateTime.now();

        return AlertDialog(
          title: const Text('Add New Stake'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Validator'),
                onChanged: (value) => validator = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount (NEAR)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value) ?? 0,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'APY (%)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => apy = double.tryParse(value) ?? 0,
              ),
              TextButton(
                child: Text(
                    'Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != startDate) {
                    setState(() {
                      startDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  stakes.add({
                    'validator': validator,
                    'amount': amount,
                    'apy': apy,
                    'status': 'Active',
                    'startDate': startDate,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

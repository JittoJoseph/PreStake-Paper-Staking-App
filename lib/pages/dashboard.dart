import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'account.dart';

class DashboardPage extends StatefulWidget {
  final bool isRealStake;

  const DashboardPage({super.key, required this.isRealStake});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isRealStake ? 'Meta Pool Dashboard' : 'Simulated Meta Pool',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D2B33),
        actions: [
          _buildNotificationIcon(),
          _buildAccountIcon(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildQuickStats(),
            const SizedBox(height: 24),
            _buildRewardsGraph(),
            const SizedBox(height: 24),
            _buildNotificationFeed(),
            const SizedBox(height: 24),
            _buildMetaPoolInfo(),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Color(0xFFCEFF1A)),
          onPressed: () {
            // TODO: Implement notification center
          },
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: const BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountIcon() {
    return IconButton(
      icon: const Icon(Icons.account_circle, color: Color(0xFFCEFF1A)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountPage()),
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(
            color: Color(0xFFCEFF1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                  'Total Staked', '1,234,567 NEAR', Icons.account_balance),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Total Rewards', '9,876 NEAR', Icons.stars),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Current APY', '12.34%', Icons.trending_up),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                  'Daily Earnings', '123.45 NEAR', Icons.access_time),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFCEFF1A), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsGraph() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rewards History',
            style: TextStyle(
                color: Color(0xFFCEFF1A),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 1),
                      const FlSpot(2, 4),
                      const FlSpot(3, 2),
                      const FlSpot(4, 5),
                      const FlSpot(5, 3),
                    ],
                    isCurved: true,
                    color: const Color(0xFF1AFFCE),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF1AFFCE).withOpacity(0.2)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationFeed() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Notifications',
            style: TextStyle(
                color: Color(0xFFCEFF1A),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildNotificationItem(
              'Reward Received', '5 NEAR added to your rewards', '2 hours ago'),
          const Divider(color: Colors.white24),
          _buildNotificationItem(
              'APY Increase', 'Pool APY increased to 13.5%', '1 day ago'),
          const Divider(color: Colors.white24),
          _buildNotificationItem('Stake Successful',
              '1000 NEAR successfully staked', '3 days ago'),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String description, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle_notifications, color: Color(0xFF1AFFCE)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(time,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaPoolInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meta Pool Info',
            style: TextStyle(
                color: Color(0xFFCEFF1A),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildMetaPoolInfoItem('Total Value Locked', '98,765,432 NEAR'),
          _buildMetaPoolInfoItem('Your stNEAR Balance', '12,345 stNEAR'),
          _buildMetaPoolInfoItem(
              'Current Exchange Rate', '1 stNEAR = 1.0563 NEAR'),
          _buildMetaPoolInfoItem('Your META Token Balance', '5,678 META'),
        ],
      ),
    );
  }

  Widget _buildMetaPoolInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
              color: Color(0xFFCEFF1A),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionButton('Stake', Icons.add)),
            const SizedBox(width: 16),
            Expanded(child: _buildActionButton('Unstake', Icons.remove)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionButton('Claim Rewards', Icons.redeem)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildActionButton('Buy META', Icons.shopping_cart)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF0D2B33),
        backgroundColor: const Color(0xFFCEFF1A),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        // TODO: Implement action logic
      },
    );
  }

  Future<void> _refreshData() async {
    // TODO: Implement refresh logic
    await Future.delayed(const Duration(seconds: 1)); // Simulated delay
  }
}

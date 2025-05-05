import 'dart:convert';
import 'package:budget_tracker/add_transaction_screen.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/data_models.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferences? prefObj;
  String ip = '';

  @override
  void initState() {
    super.initState();
    loadPrefAndFetch();
  }

  Future<void> loadPrefAndFetch() async {
    prefObj = await SharedPreferences.getInstance();
    setState(() {
      ip = prefObj?.getString('ip') ?? '';
    });

    if (ip.isNotEmpty) {
      fetchTransaction(); // Fetch transactions only if IP is valid
    } else {
      print("No valid IP found");
    }
  }

  int totalIncome = 0;
  int totalExpenses = 0;
  List<Transaction> transactions = [];

  Future<List<Transaction>> viewTransaction() async {
    String url = 'http://$ip/budget_tracker/viewTransaction.php';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => Transaction.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load transactions");
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<void> fetchTransaction() async {
    List<Transaction> fetchedTransaction = await viewTransaction();

    int income = 0;
    int expenses = 0;

    for (var transaction in fetchedTransaction) {
      int amount = int.tryParse(transaction.amount) ?? 0;
      if (transaction.type == "income") {
        income += amount;
      } else if (transaction.type == "expense") {
        expenses += amount;
      }
    }

    setState(() {
      transactions = fetchedTransaction;
      totalIncome = income;
      totalExpenses = expenses;
    });
  }

  // Function to delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    String url = 'http://$ip/budget_tracker/deleteTransaction.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'id': transactionId,
        },
      );

      var jsonData = jsonDecode(response.body);
      if (jsonData['message'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully')),
        );
        fetchTransaction(); // Refresh the list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete transaction')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${totalIncome - totalExpenses}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem('Income', totalIncome, Colors.green),
                        _buildSummaryItem('Expenses', totalExpenses, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Flow Chart
            Container(
              height: 250,
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Updated title with better description
                  const Text(
                    'Daily Income & Expenses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Last 7 Days',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 2000,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          // Improved bottom titles with day names
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() > 7) return const Text('');
                                final date = DateTime.now().subtract(Duration(days: (7 - value).toInt()));
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _getShortDayName(date.weekday),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 25, // Reduced from 40 since we're showing less content
                            ),
                          ),
                          // Improved left titles with currency formatting
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text(
                              'Amount (₹)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, meta) {
                                // Format the amount in thousands (K)
                                return Text(
                                  value >= 1000 
                                      ? '₹${(value/1000).toStringAsFixed(1)}K'
                                      : '₹${value.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                              interval: 2000,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 7,
                        minY: 0,
                        maxY: (totalIncome > totalExpenses ? totalIncome : totalExpenses) * 1.2,
                        lineBarsData: [
                          // Income Line
                          LineChartBarData(
                            spots: _getDailySpots(transactions, "income"),
                            isCurved: false, // Straight lines for clearer representation
                            color: Colors.green,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.white,
                                  strokeWidth: 3,
                                  strokeColor: Colors.green,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.green.withOpacity(0.1),
                            ),
                          ),
                          // Expense Line
                          LineChartBarData(
                            spots: _getDailySpots(transactions, "expense"),
                            isCurved: false, // Straight lines for clearer representation
                            color: Colors.red,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.white,
                                  strokeWidth: 3,
                                  strokeColor: Colors.red,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.red.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Add legend below the chart
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Income'),
                  ],
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Expenses'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Transactions List
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            transactions.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            transaction.type == "income"
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: transaction.type == "income"
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(transaction.title.toSentenceCase(),style: TextStyle(fontWeight: FontWeight.w600),),
                          subtitle: Text(transaction.date,style: TextStyle(color: Colors.grey.shade500),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹${transaction.amount}',
                                style: TextStyle(
                                  color: transaction.type == "income"
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteTransaction(transaction.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, int amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          '₹$amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getDailySpots(List<Transaction> transactions, String type) {
    Map<int, double> dailyTotals = {};
    final now = DateTime.now();

    // Initialize the last 7 days with 0
    for (int i = 0; i <= 7; i++) {
      dailyTotals[i] = 0;
    }

    // Calculate totals for each day
    for (var transaction in transactions) {
      if (transaction.type == type) {
        final date = DateTime.parse(transaction.date);
        final daysAgo = now.difference(date).inDays;
        if (daysAgo <= 7) {
          final dayIndex = 7 - daysAgo;
          dailyTotals[dayIndex] = (dailyTotals[dayIndex] ?? 0) + double.parse(transaction.amount);
        }
      }
    }

    // Convert to list of FlSpots
    return dailyTotals.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  String _getShortDayName(int weekday) {
  switch (weekday) {
    case 1: return 'Mon';
    case 2: return 'Tue';
    case 3: return 'Wed';
    case 4: return 'Thu';
    case 5: return 'Fri';
    case 6: return 'Sat';
    case 7: return 'Sun';
    default: return '';
  }
}
}

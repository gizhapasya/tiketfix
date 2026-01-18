import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/order_remote_datasource.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = OrderRemoteDataSource().getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Purchase Statistics")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("No statistics data available yet."));
          }

          final data = snapshot.data!;
          final movieStats = data['tickets_per_movie'] as Map<String, dynamic>;
          // final expenditureStats = data['expenditure_history'] as List<dynamic>;

          // Prepare Bar Chart Data
          List<BarChartGroupData> barGroups = [];
          int index = 0;
          movieStats.forEach((key, value) {
             barGroups.add(
               BarChartGroupData(
                 x: index,
                 barRods: [
                   BarChartRodData(
                     toY: double.parse(value.toString()), 
                     color: Colors.blueAccent, 
                     width: 16,
                     borderRadius: BorderRadius.circular(4),
                   )
                 ],
               )
             );
             index++;
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tickets per Movie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: barGroups.isEmpty 
                    ? const Center(child: Text("No ticket data"))
                    : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: barGroups,
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value.toInt() < movieStats.keys.length) {
                                     // Show first 3 chars of title to save space
                                     String title = movieStats.keys.elementAt(value.toInt());
                                     return Padding(
                                       padding: const EdgeInsets.only(top: 8.0),
                                       child: Text(title.length > 5 ? "${title.substring(0, 5)}..." : title, style: const TextStyle(fontSize: 10)),
                                     );
                                  }
                                  return const Text("");
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: true, drawVerticalLine: false),
                        ),
                      ),
                ),
                const SizedBox(height: 40),
                // Could add expenditures chart here similarly
              ],
            ),
          );
        },
      ),
    );
  }
}

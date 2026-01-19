import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

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
      appBar: AppBar(
        title: const Text("Purchase Statistics"),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: AppColors.error)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("No statistics data available yet.", style: AppTextStyles.body));
          }

          final data = snapshot.data!;
          final movieStats = data['tickets_per_movie'] as Map<String, dynamic>;

          List<BarChartGroupData> barGroups = [];
          int index = 0;
          movieStats.forEach((key, value) {
             barGroups.add(
               BarChartGroupData(
                 x: index,
                 barRods: [
                   BarChartRodData(
                     toY: double.parse(value.toString()), 
                     color: AppColors.primary, 
                     width: 20,
                     borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                     backDrawRodData: BackgroundBarChartRodData(
                       show: true,
                       toY: 10, // Assuming max or dynamic
                       color: AppColors.surface,
                     )
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                       const Text("Tickets per Movie", style: AppTextStyles.h2),
                       const SizedBox(height: 32),
                       SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: barGroups.isEmpty 
                          ? const Center(child: Text("No ticket data", style: AppTextStyles.body))
                          : BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                barGroups: barGroups,
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true, 
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: AppTextStyles.bodySmall),
                                    )
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (double value, TitleMeta meta) {
                                        if (value.toInt() < movieStats.keys.length) {
                                           String title = movieStats.keys.elementAt(value.toInt());
                                           return Padding(
                                             padding: const EdgeInsets.only(top: 8.0),
                                             child: Text(
                                               title.length > 6 ? "${title.substring(0, 6)}..." : title, 
                                               style: AppTextStyles.bodySmall.copyWith(fontSize: 10)
                                             ),
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
                                gridData: FlGridData(
                                  show: true, 
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/models/transaction_model.dart';
import 'transaction_detail_page.dart';
import '../../core/utils/pdf_generator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late Future<List<TransactionModel>> _historyFuture;
  List<TransactionModel>? _loadedTransactions; // Cache for export

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<List<TransactionModel>> _fetchHistory() async {
    final data = await OrderRemoteDataSource().getTransactionHistory();
    // Cache data
    final list = data.map((e) => TransactionModel.fromJson(e)).toList();
    _loadedTransactions = list;
    return list;
  }
  
  Future<void> _exportPdf() async {
     if (_loadedTransactions == null || _loadedTransactions!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No data to export")));
        return;
     }
     
     try {
       await PdfGenerator.generateAndSave(_loadedTransactions!);
       // Success message handled by opening file usually, but showing snackbar is good
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Export saved!")));
     } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Export failed: $e")));
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tickets"),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: _exportPdf,
          )
        ],
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: AppColors.error)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No transaction history.", style: AppTextStyles.body));
          }

          final transactions = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final item = transactions[index];
              
              return GestureDetector(
                onTap: () {
                   Navigator.push(
                     context, 
                     MaterialPageRoute(builder: (context) => TransactionDetailPage(transaction: item))
                   );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.movie, color: Colors.white54),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: AppTextStyles.h2.copyWith(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text("${item.studioName} • ${item.startTime}", style: AppTextStyles.bodySmall),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item.orderDate, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
                                  Text("Rp ${item.totalPrice}", style: AppTextStyles.body.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

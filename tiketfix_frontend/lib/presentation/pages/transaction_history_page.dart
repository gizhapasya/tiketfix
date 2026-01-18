import 'package:flutter/material.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/models/transaction_model.dart';
import 'transaction_detail_page.dart';
import '../../core/utils/pdf_generator.dart';


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
       // OpenFile opens it system-wide.
     } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Export failed: $e")));
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tickets"),
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No transaction history."));
          }

          final transactions = snapshot.data!;
          return ListView.builder(
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
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Studio: ${item.studioName} | ${item.startTime}"),
                        Text("Seats: ${item.seats}"),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.orderDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("Rp ${item.totalPrice}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        )
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

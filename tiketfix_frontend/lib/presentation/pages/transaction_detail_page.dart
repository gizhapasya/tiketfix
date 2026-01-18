import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../core/constants/api_constants.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ticket Detail")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ticket Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  // Header / Movie Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: transaction.posterUrl != null
                        ? Image.network(
                            // Ensure URL is complete
                            transaction.posterUrl!.startsWith('http') 
                                ? transaction.posterUrl!
                                : '${ApiConstants.baseUrl}/../${transaction.posterUrl}', // Assuming relative path
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.broken_image, size: 50)),
                            ),
                          )
                        : Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.blueAccent,
                            child: const Center(child: Icon(Icons.movie, size: 60, color: Colors.white)),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        _buildRow(Icons.calendar_today, "Date", transaction.startTime),
                        const SizedBox(height: 12),
                        _buildRow(Icons.location_on, "Studio", transaction.studioName),
                        const SizedBox(height: 12),
                        _buildRow(Icons.event_seat, "Seats", transaction.seats),
                        const SizedBox(height: 12),
                        _buildRow(Icons.attach_money, "Total Price", "Rp ${transaction.totalPrice}"),
                        const SizedBox(height: 12),
                         _buildRow(Icons.numbers, "Order ID", "#${transaction.id}"),
                        const SizedBox(height: 20),
                        // QR Code Placeholder
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                color: Colors.black12,
                                child: const Icon(Icons.qr_code_2, size: 100),
                              ),
                              const SizedBox(height: 8),
                              const Text("Show this QR code at the entrance"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }
}

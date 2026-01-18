import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../data/models/transaction_model.dart';

class PdfGenerator {
  static Future<void> generateAndSave(List<TransactionModel> transactions) async {
    final pdf = pw.Document();

    // Use built-in font or load one. Default font works for basic text.
    // For Rp (Rupiah), standard font is fine.

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text("TicketFix - Purchase History", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Generated on: ${DateTime.now().toString().split('.')[0]}"),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
              cellAlignment: pw.Alignment.centerLeft,
              data: <List<String>>[
                <String>['Date', 'Movie', 'Studio/Time', 'Seats', 'Price'],
                ...transactions.map(
                  (item) => [
                    item.orderDate,
                    item.title,
                    "${item.studioName}\n${item.startTime}",
                    item.seats,
                    "Rp ${item.totalPrice}"
                  ]
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Footer(
               leading: pw.Text("TicketFix App"),
               trailing: pw.Text("Page 1"), // Simple pagination placeholder
            )
          ];
        },
      ),
    );

    try {
      // Get app documentation directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/ticketfix_history_${DateTime.now().millisecondsSinceEpoch}.pdf");
      
      await file.writeAsBytes(await pdf.save());
      
      // Open the file
      await OpenFile.open(file.path);
    } catch (e) {
      // Re-throw to handle in UI
      throw Exception("Failed to save or open PDF: $e");
    }
  }
}

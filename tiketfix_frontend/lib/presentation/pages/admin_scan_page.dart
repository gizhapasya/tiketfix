import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';

class AdminScanPage extends StatefulWidget {
  const AdminScanPage({super.key});

  @override
  State<AdminScanPage> createState() => _AdminScanPageState();
}

class _AdminScanPageState extends State<AdminScanPage> {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  Future<void> _verifyTicket(String code) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/transactions/verify_ticket.php'),
        body: {'code': code},
      );

      final result = json.decode(response.body);
      
      if (!mounted) return;

      if (result['success'] == true) {
        _showDialog("Success", result['message'], Colors.green);
      } else {
        _showDialog("Failed", result['message'], Colors.red);
      }
    } catch (e) {
      if (mounted) _showDialog("Error", "Network error: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showDialog(String title, String message, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Resume scanning or just reset processing
              // Scanner usually continues unless stopped
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Scanner")),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _verifyTicket(barcode.rawValue!);
                    break; // Process first code found
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _isProcessing 
                ? const CircularProgressIndicator()
                : const Text("Scan a ticket QR code"),
            ),
          )
        ],
      ),
    );
  }
}

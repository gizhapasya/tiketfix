import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/schedule_model.dart';
import '../../data/datasources/order_remote_datasource.dart';

class OrderPage extends StatefulWidget {
  final MovieModel movie;
  final ScheduleModel schedule;

  const OrderPage({
    super.key,
    required this.movie,
    required this.schedule,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _selectedSeatCount = 1;
  bool _isLoading = false;
  final _orderDataSource = OrderRemoteDataSource();

  double get _totalPrice => widget.schedule.price * _selectedSeatCount;

  Future<void> _processOrder() async {
    setState(() => _isLoading = true);
    try {
      // Simulate simple seat selection like "A1, A2"
      String seats = List.generate(_selectedSeatCount, (index) => "Seat ${index + 1}").join(", ");

      final result = await _orderDataSource.createOrder(
        movieId: widget.movie.id,
        scheduleId: widget.schedule.id,
        seats: seats,
        totalPrice: _totalPrice,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Order placed successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Close Order Page
                  Navigator.pop(context); // Close Detail Page (optional, simplify flow)
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(result['message'] ?? "Order failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Ticket")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Schedule: ${widget.schedule.startTime}"),
            Text("Studio: ${widget.schedule.studioName}"),
            Text("Price per ticket: Rp ${widget.schedule.price}"),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text("Tickets: ", style: TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: _selectedSeatCount > 1 ? () => setState(() => _selectedSeatCount--) : null,
                  icon: const Icon(Icons.remove_circle),
                ),
                Text("$_selectedSeatCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => setState(() => _selectedSeatCount++),
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text("Total: Rp $_totalPrice", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _processOrder,
                child: _isLoading ? const CircularProgressIndicator() : const Text("Confirm Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/schedule_model.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

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
            backgroundColor: AppColors.surface,
            title: const Text("Success", style: AppTextStyles.h2),
            content: const Text("Order placed successfully!", style: AppTextStyles.body),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Close Order Page
                  Navigator.pop(context); // Close Detail Page (optional, simplify flow)
                },
                child: const Text("OK", style: TextStyle(color: AppColors.primary)),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(result['message'] ?? "Order failed", style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Error: $e", style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error),
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title, style: AppTextStyles.h1.copyWith(fontSize: 22)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text("Schedule: ${widget.schedule.startTime}", style: AppTextStyles.body),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text("Studio: ${widget.schedule.studioName}", style: AppTextStyles.body),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text("Price: Rp ${widget.schedule.price}", style: AppTextStyles.body),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text("Select Tickets", style: AppTextStyles.h2),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: _selectedSeatCount > 1 ? () => setState(() => _selectedSeatCount--) : null,
                  icon: const Icon(Icons.remove_circle, color: AppColors.primary, size: 32),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("$_selectedSeatCount", style: AppTextStyles.h1),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedSeatCount++),
                  icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Payment", style: AppTextStyles.body),
                Text("Rp $_totalPrice", style: AppTextStyles.h1.copyWith(color: AppColors.success)),
              ],
            ),
            const Spacer(),
            CustomButton(
              text: "Confirm Order",
              onPressed: _processOrder,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

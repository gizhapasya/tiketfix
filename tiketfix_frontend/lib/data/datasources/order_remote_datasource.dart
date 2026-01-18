import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class OrderRemoteDataSource {
  final http.Client client;

  OrderRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> createOrder({
    required int movieId,
    required int scheduleId,
    required String seats,
    required double totalPrice,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? 'Guest'; // Fallback if not logged in properly

      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/orders/create_order.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'movie_id': movieId,
          'schedule_id': scheduleId,
          'user_name': username,
          'seats': seats,
          'total_price': totalPrice,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Order error: $e');
    }
  }

  Future<List<dynamic>> getTransactionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');

      if (username == null) return [];

      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/transactions/get_history.php?username=$username'),
      );

      if (response.statusCode == 200) {
         final Map<String, dynamic> responseData = json.decode(response.body);
         if (responseData['success'] == true) {
           return responseData['data'];
         } else {
           return [];
         }
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      throw Exception('History error: $e');
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      if (username == null) return {};

      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/transactions/dashboard_stats.php?username=$username'),
      );

      if (response.statusCode == 200) {
         final Map<String, dynamic> responseData = json.decode(response.body);
         if (responseData['success'] == true) {
           return responseData['data'];
         } else {
           return {};
         }
      } else {
        throw Exception('Failed to load stats');
      }
    } catch (e) {
      throw Exception('Stats error: $e');
    }
  }
}

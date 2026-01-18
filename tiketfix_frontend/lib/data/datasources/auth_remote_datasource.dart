import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/users/login.php'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to connect to server (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/users/register.php'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to connect to server (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}

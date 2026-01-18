import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/movie_model.dart';
import '../models/schedule_model.dart';

class MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<MovieModel>> getMovies() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/movie_api/get_movies.php'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'];
          return data.map((e) => MovieModel.fromJson(e)).toList();
        } else {
          throw Exception('Failed to load movies: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  Future<List<ScheduleModel>> getSchedules(int movieId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/schedules/get_schedules.php?movie_id=$movieId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'];
          return data.map((e) => ScheduleModel.fromJson(e)).toList();
        } else {
          return []; // Return empty list if no schedules or error, or throw exception
        }
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e) {
      throw Exception('Error fetching schedules: $e');
    }
  }
}

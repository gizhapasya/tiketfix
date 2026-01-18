import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/schedule_model.dart';
import '../../data/datasources/movie_remote_datasource.dart';
import 'order_page.dart';


class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<List<ScheduleModel>> _schedulesFuture;

  @override
  void initState() {
    super.initState();
    _schedulesFuture = MovieRemoteDataSource().getSchedules(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster Placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.movie, size: 64, color: Colors.grey)),
              // For real image: Image.network(widget.movie.posterUrl)
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.genre,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.movie.description),
                  const SizedBox(height: 24),
                  const Text(
                    "Schedules",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<ScheduleModel>>(
                    future: _schedulesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error loading schedules: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No schedules available.");
                      }

                      final schedules = snapshot.data!;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: schedules.map((schedule) {
                          return ActionChip(
                            label: Text("${schedule.studioName} - ${schedule.startTime}"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderPage(
                                    movie: widget.movie, 
                                    schedule: schedule
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

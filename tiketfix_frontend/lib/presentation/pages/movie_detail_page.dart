import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/schedule_model.dart';
import '../../data/datasources/movie_remote_datasource.dart';
import 'order_page.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.movie.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster Placeholder
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.background],
                ),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/500x300?text=Cinema'), // Placeholder or fallback
                  fit: BoxFit.cover,
                  opacity: 0.5,
                )
              ),
              child: const Center(
                child: Icon(Icons.play_circle_outline, size: 80, color: Colors.white70),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: AppTextStyles.h1,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           decoration: BoxDecoration(
                             color: AppColors.primary,
                             borderRadius: BorderRadius.circular(4),
                           ),
                           child: Text(widget.movie.genre, style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text("4.5", style: AppTextStyles.body), // Hardcoded rating for demo
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, color: Colors.grey, size: 18),
                        const SizedBox(width: 4),
                        Text("120 mins", style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Storyline",
                      style: AppTextStyles.h2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.movie.description,
                      style: AppTextStyles.body.copyWith(color: Colors.grey[400], height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Schedules",
                      style: AppTextStyles.h2,
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<ScheduleModel>>(
                      future: _schedulesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                        } else if (snapshot.hasError) {
                          return Text("Error loading schedules: ${snapshot.error}", style: const TextStyle(color: AppColors.error));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text("No schedules available.", style: AppTextStyles.body);
                        }

                        final schedules = snapshot.data!;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: schedules.map((schedule) {
                            return InkWell(
                              onTap: () {
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                                ),
                                child: Column(
                                  children: [
                                    Text(schedule.startTime, style: AppTextStyles.h2.copyWith(fontSize: 18)),
                                    const SizedBox(height: 4),
                                    Text(schedule.studioName, style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

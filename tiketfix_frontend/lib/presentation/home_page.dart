import 'package:flutter/material.dart';
import 'package:tiketfix/data/datasources/movie_remote_datasource.dart';
import 'package:tiketfix/presentation/widgets/movie_card_widget.dart';
import 'package:tiketfix/core/theme/app_colors.dart';
import 'package:tiketfix/core/theme/app_text_styles.dart';
import '../data/models/movie_model.dart';
import 'package:tiketfix/core/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<MovieModel>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieRemoteDataSource().getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('TicketFix'),
        centerTitle: true,
        backgroundColor: AppColors.background.withOpacity(0.8),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: AppColors.textPrimary),
            tooltip: 'My Tickets',
            onPressed: () {
               Navigator.pushNamed(context, AppRoutes.transactions);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: AppColors.textPrimary),
            tooltip: 'Statistics',
            onPressed: () {
               Navigator.pushNamed(context, AppRoutes.dashboard);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.textPrimary),
            tooltip: 'Profile',
            onPressed: () {
               Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              Color(0xFF000000),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100), // Space for AppBar
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      color: AppColors.primary,
                      margin: const EdgeInsets.only(right: 8),
                    ),
                    const Text(
                      'Now Showing',
                      style: AppTextStyles.h2,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<MovieModel>>(
                  future: _moviesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: AppColors.error)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No movies available", style: AppTextStyles.body));
                    }

                    final movies = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return MovieCardWidget(movie: movies[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

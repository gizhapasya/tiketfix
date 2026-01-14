import 'package:flutter/material.dart';
import 'package:tiketfix/presentation/pages/widgets/controllers/movie_card.dart';
import 'package:tiketfix/core/app_routes.dart';
import 'package:tiketfix/data/models/detasources/repositories/dummy/movie_dummy.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TicketFix'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Now Showing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    title: movieList[index].title,
                    genre: movieList[index].genre,
                    duration: movieList[index].duration,
                    rating: movieList[index].rating,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

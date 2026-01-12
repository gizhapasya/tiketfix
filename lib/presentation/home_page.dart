import 'package:flutter/material.dart';
import 'package:tiketfix/presentation/pages/widgets/controllers/movie_card.dart';

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
              Navigator.pushReplacementNamed(context, '/login');
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
              child: ListView(
                children: const [
                  MovieCard(
                    title: 'Avengers: End Game',
                    genre: 'Action, Sci-Fi',
                  ),
                  MovieCard(
                    title: 'Dilan 1990',
                    genre: 'Romance',
                  ),
                  MovieCard(
                    title: 'Pengabdi Setan',
                    genre: 'Horror',
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

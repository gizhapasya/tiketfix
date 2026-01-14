import 'package:flutter/material.dart';
import 'package:tiketfix/domain/entities/repositories/usecases/movie.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String genre;
  final String? duration;
  final String? rating;

  const MovieCard({
    super.key,
    required this.title,
    required this.genre,
    this.duration,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.movie),
        title: Text(title),
        subtitle: Text(duration != null ? '$genre • $duration' : genre),
        trailing: rating != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.orange),
                  Text(rating!),
                ],
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text(title)),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Genre: $genre', style: const TextStyle(fontSize: 16)),
                      if (duration != null) ...[
                        const SizedBox(height: 8),
                        Text('Duration: $duration'),
                      ],
                      if (rating != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.orange),
                            const SizedBox(width: 6),
                            Text(rating!),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

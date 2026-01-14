import 'package:flutter/material.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pilih film: $title')),
          );
        },
      ),
    );
  }
}

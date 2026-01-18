import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String genre;

  const MovieCard({
    super.key,
    required this.title,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: const Icon(Icons.movie),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(genre),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to details if needed
        },
      ),
    );
  }
}

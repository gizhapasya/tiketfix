import 'package:flutter/material.dart';
import 'package:tiketfix/domain/entities/repositories/usecases/movie.dart';

class BookingSummaryPage extends StatelessWidget {
  final Movie movie;
  final String schedule;
  final String name;
  final int ticketCount;

  const BookingSummaryPage({
    super.key,
    required this.movie,
    required this.schedule,
    required this.name,
    required this.ticketCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Tiket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pemesanan Berhasil 🎉',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text('Nama: $name'),
            Text('Film: ${movie.title}'),
            Text('Jadwal: $schedule'),
            Text('Jumlah Tiket: $ticketCount'),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Kembali ke Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tiketfix/domain/entities/repositories/usecases/movie.dart';
import 'booking_summary_page.dart';

class BookingPage extends StatefulWidget {
  final Movie movie;
  final String schedule;

  const BookingPage({
    super.key,
    required this.movie,
    required this.schedule,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final nameController = TextEditingController();
  int ticketCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan Tiket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movie.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Jadwal: ${widget.schedule}'),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemesan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text('Jumlah Tiket'),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (ticketCount > 1) {
                      setState(() => ticketCount--);
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  ticketCount.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => ticketCount++);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nama harus diisi')),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingSummaryPage(
                        movie: widget.movie,
                        schedule: widget.schedule,
                        name: nameController.text,
                        ticketCount: ticketCount,
                      ),
                    ),
                  );
                },
                child: const Text('Pesan Tiket'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

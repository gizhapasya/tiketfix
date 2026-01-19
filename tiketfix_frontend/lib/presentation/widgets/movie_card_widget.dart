import 'package:flutter/material.dart';
import 'package:tiketfix/data/models/movie_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../pages/movie_detail_page.dart';
import 'package:tiketfix/core/constants/api_constants.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieModel movie;

  const MovieCardWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(movie: movie),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for Image since backend doesn't seem to provide image URL explicitly or it's just local?
            // Assuming we want a nice placeholder or if the model has a poster path.
            // Looking at MovieModel usage in previous MovieCard, it just had title and genre.
            // We will add a cinematic placeholder.
            SizedBox(
              height: 180,
              width: double.infinity,
              child: movie.posterUrl.isNotEmpty
                  ? Image.network(
                      "${ApiConstants.baseUrl}/${movie.posterUrl}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          alignment: Alignment.center,
                          child: const Icon(Icons.movie_filter, size: 64, color: AppColors.textSecondary),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.movie_filter, size: 64, color: AppColors.textSecondary),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: AppTextStyles.h2.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NOW SHOWING',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                   ),
                   const SizedBox(height: 6),
                   Text(
                     movie.genre,
                     style: AppTextStyles.bodySmall,
                   ),
                   const SizedBox(height: 12),
                   Row(
                     children: [
                       const Icon(Icons.star, color: Colors.amber, size: 16),
                       const SizedBox(width: 4),
                       Text('Rating', style: AppTextStyles.bodySmall),
                       const Spacer(),
                       Text('Book Now', style: AppTextStyles.button.copyWith(color: AppColors.primary, fontSize: 14)),
                       const SizedBox(width: 4),
                       const Icon(Icons.arrow_forward, color: AppColors.primary, size: 16),
                     ],
                   )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

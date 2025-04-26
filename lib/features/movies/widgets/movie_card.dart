import 'package:flutter/material.dart';
import 'package:solguruz_practical_task/features/movies/view/movies_screen.dart';
import 'package:solguruz_practical_task/features/widgets/custom_image_view.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isGridView;
  final List<Genre> genres;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isGridView,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final movieGenres = movie.genreIds
          .map((genreId) => genres.firstWhere((genre) => genre.id == genreId))
          .toList();
    } catch (e) {
      // Do nothing
    }

    return isGridView
        ? _buildGridViewCard(context, genres)
        : _buildListViewCard(context, genres);
  }

  _buildGridViewCard(BuildContext context, List<Genre> genres) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MoviesScreen(),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            CustomImageView(
              imagePath: movie.posterPath,
              radius: BorderRadius.circular(16),
              height: 200.h,
              width: double.infinity,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  movie.releaseDate.year.toString(),
                  style: Styles.bodyMedium.copyWith(
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16.h,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: Styles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                movie.title,
                style: Styles.titleSmall.copyWith(
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  _buildListViewCard(BuildContext context, List<Genre> genres) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MoviesScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(10.h),
        child: Row(
          children: [
            CustomImageView(
              imagePath: movie.posterPath,
              radius: BorderRadius.circular(10),
              height: 100.h,
              width: 100.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                movie.title,
                style: Styles.titleSmall.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:solguruz_practical_task/features/widgets/custom_image_view.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';
import 'package:solguruz_practical_task/routing/app_routing.dart';
import 'package:solguruz_practical_task/services/navigator_service.dart';
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
    List<Genre> movieGenres = [];
    try {
      movieGenres = movie.genreIds
          .map((genreId) => genres.firstWhere((genre) => genre.id == genreId))
          .toList();
    } catch (e) {
      // Do nothing
    }

    return isGridView
        ? _buildGridViewCard(context, movieGenres)
        : _buildListViewCard(context, movieGenres);
  }

  _buildGridViewCard(BuildContext context, List<Genre> genres) {
    return InkWell(
      onTap: () {
        NavigatorService.push(
          AppRouting.movieDetailsPath,
          arguments: {
            'movieId': movie.id,
          },
        );
      },
      radius: 16,
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
                  style: Styles.bodyMedium.copyWith(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Styles.titleMedium.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 5.h),
                  // / separated by genres
                  Text(
                    genres.map((genre) => genre.name).join(' / '),
                    style: Styles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildListViewCard(BuildContext context, List<Genre> genres) {
    return InkWell(
      onTap: () {
        NavigatorService.push(
          AppRouting.movieDetailsPath,
          arguments: {
            'movieId': movie.id,
          },
        );
      },
      radius: 16,
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: CustomImageView(
                imagePath: movie.posterPath,
                height: 120.h,
                width: double.infinity,
                radius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Styles.titleSmall.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    // genre separated by comma
                    Text(
                      genres.map((genre) => genre.name).join(' | '),
                      style: Styles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          movie.releaseDate.year.toString(),
                          style: Styles.bodyMedium.copyWith(),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/constants/assets_constants.dart';
import 'package:solguruz_practical_task/features/movie_details/cubit/movie_details_cubit.dart';
import 'package:solguruz_practical_task/features/widgets/base_screen.dart';
import 'package:solguruz_practical_task/features/widgets/custom_image_view.dart';
import 'package:solguruz_practical_task/features/widgets/error_message_widget.dart';
import 'package:solguruz_practical_task/models/movie_details_model.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDetailsCubit>().getMovieDetails(movieId: widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      horizontalPadding: 0,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 16.h,
        ),
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {},
          child: CustomImageView(
            imagePath: ticketIcon,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.cover,
            color: Colors.white,
          ),
        ),
      ),
      child: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        builder: (context, state) {
          return state.status == MovieDetailsStatus.loading
              ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ))
              : state.status == MovieDetailsStatus.failure ||
              state.movieDetails == null
              ? ErrorMessageWidget(message: state.errorMessage)
              : MovieDetailsContent(movieDetails: state.movieDetails);
        },
      ),
    );
  }

}

class MovieDetailsContent extends StatelessWidget {
  final MovieDetails? movieDetails;

  const MovieDetailsContent({super.key, this.movieDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerWidget(context, movieDetails),
          SizedBox(height: 90.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailChips(
                  movieDetails?.voteAverage ?? 0,
                  movieDetails?.voteCount ?? 0,
                ),
                SizedBox(height: 16.h),
                Text(
                  movieDetails?.title ?? '',
                  style: Styles.titleLarge,
                ),
                SizedBox(height: 8.h),
                // genre separated by comma
                Text(
                  movieDetails?.genres
                      .map((genre) => genre.name)
                      .join(' | ') ??
                      '',
                  style: Styles.bodySmall,
                ),
                SizedBox(height: 18.h),
                Text(
                  movieDetails?.overview ?? '',
                  style: Styles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 24.h),
                if(movieDetails?.productionCompanies.isNotEmpty ?? false)
                  _productionCompanies(
                    movieDetails?.productionCompanies ?? [],
                  ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }


  _blurredBackDropImage(String imagePath) {
    return SizedBox(
      width: double.infinity,
      height: 320.h,
      child: Stack(
        children: [
          CustomImageView(
            imagePath: imagePath,
            width: double.infinity,
            height: 320.h,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  _moviePoster(String imagePath) {
    return Container(
      width: 180.w,
      height: 240.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: CustomImageView(
        imagePath: imagePath,
        width: 120.w,
        height: 180.h,
        fit: BoxFit.cover,
        radius: BorderRadius.circular(16),
      ),
    );
  }

  _detailChips(double rating, int voteCount) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          child: Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: Colors.yellow,
                size: 22.w,
              ),
              SizedBox(width: 4.w),
              Text(
                rating.toString(),
                style: Styles.bodyMedium.copyWith(color: Colors.white),
              ),
              SizedBox(width: 8.w),
              Text(
                '($voteCount votes)',
                style: Styles.bodySmall.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(width: 22.w),
        Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                color: Colors.yellow,
                size: 18.w,
              ),
              SizedBox(width: 8.w),
              Text(
                runTime,
                style: Styles.bodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _headerWidget(BuildContext context, MovieDetails? movieDetails) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _blurredBackDropImage(
          movieDetails?.backdropPath ?? '',
        ),
        Positioned(
          top: 32.h,
          left: 22.w,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(8.w),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60.h,
          left: 20.w,
          child: _moviePoster(
            movieDetails?.posterPath ?? '',
          ),
        )
      ],
    );
  }

  _productionCompanies(List<ProductionCompanies> productionCompany,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Production Companies',
          style: Styles.titleMedium,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          height: 60.h,
          child: ListView.builder(
            itemCount: movieDetails
                ?.productionCompanies.length ??
                0,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ProductionCompanies? productionCompany =
              movieDetails
                  ?.productionCompanies[index];
              return productionCompany == null ||
                  productionCompany.logoPath.isEmpty
                  ? const SizedBox()
                  : Padding(
                padding:
                EdgeInsets.only(right: 8.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(50),
                  ),
                  height: 60.h,
                  width: 60.w,
                  padding: EdgeInsets.all(4.w),
                  child: CustomImageView(
                    imagePath: productionCompany
                        .logoPath,
                    fit: BoxFit.fitWidth,
                    radius:
                    BorderRadius.circular(50),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String get runTime {
    int hours = (movieDetails?.runTime.toInt() ?? 0) ~/ 60;
    int minutes = (movieDetails?.runTime.toInt() ?? 0) % 60;
    return '$hours h $minutes min';
  }
}


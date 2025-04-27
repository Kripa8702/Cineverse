import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/features/filter_movies/cubit/filter_movies_cubit.dart';
import 'package:solguruz_practical_task/features/filter_movies/widgets/filter_section.dart';
import 'package:solguruz_practical_task/features/movies/cubit/movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/widgets/movies_screen_tabs.dart';
import 'package:solguruz_practical_task/features/widgets/base_screen.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoviesCubit>().initMovies(movieType: MovieType.popular);
    context.read<MoviesCubit>().initMovies(movieType: MovieType.topRated);
    context.read<MoviesCubit>().initMovies(movieType: MovieType.upcoming);
    context.read<MoviesCubit>().initGenres();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: BlocConsumer<MoviesCubit, MoviesState>(
        listener: (context, state) {
          if (state.popularMoviesStatus == MoviesStatus.success) {
            context.read<FilterMoviesCubit>().initMovies(
                  popularMovies: state.popularMovies,
                );
          }
          if (state.topRatedMoviesStatus == MoviesStatus.success) {
            context.read<FilterMoviesCubit>().initMovies(
                  topRatedMovies: state.topRatedMovies,
                );
          }
          if (state.upcomingMoviesStatus == MoviesStatus.success) {
            context.read<FilterMoviesCubit>().initMovies(
                  upcomingMovies: state.upcomingMovies,
                );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 50.h,
              ),
              FilterSection(genres: state.genres),
              SizedBox(
                height: 16.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _listingViewButton(
                    context,
                    isGridView: true,
                    chosen: state.gridView,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  _listingViewButton(
                    context,
                    isGridView: false,
                    chosen: !state.gridView,
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: MoviesScreenTabs(
                  popularMovies: state.popularMovies,
                  topRatedMovies: state.topRatedMovies,
                  upcomingMovies: state.upcomingMovies,
                  popularMoviesStatus: state.popularMoviesStatus,
                  topRatedMoviesStatus: state.topRatedMoviesStatus,
                  upcomingMoviesStatus: state.upcomingMoviesStatus,
                  genres: state.genres,
                  gridView: state.gridView,
                  errorMessage: state.errorMessage,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  _listingViewButton(
    BuildContext context, {
    required bool isGridView,
    required bool chosen,
  }) {
    return GestureDetector(
      child: Icon(
        isGridView ? Icons.grid_view_rounded : Icons.list_rounded,
        color: chosen ? primaryColor : Colors.white,
        size: 18.h,
      ),
      onTap: () {
        context.read<MoviesCubit>().toggleGridView(isGridView);
      },
    );
  }
}

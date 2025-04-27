import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/features/filter_movies/cubit/filter_movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/cubit/movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/widgets/movie_card.dart';
import 'package:solguruz_practical_task/features/widgets/custom_button.dart';
import 'package:solguruz_practical_task/features/widgets/error_message_widget.dart';
import 'package:solguruz_practical_task/features/widgets/pagination_list_widget.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

const List<String> _tabs = ["Popular", "Top Rated", "Upcoming"];

class MoviesScreenTabs extends StatefulWidget {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;

  final MoviesStatus popularMoviesStatus;
  final MoviesStatus topRatedMoviesStatus;
  final MoviesStatus upcomingMoviesStatus;

  final List<Genre> genres;
  final bool gridView;
  final String errorMessage;

  const MoviesScreenTabs({
    super.key,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.upcomingMovies,
    required this.popularMoviesStatus,
    required this.topRatedMoviesStatus,
    required this.upcomingMoviesStatus,
    required this.genres,
    required this.gridView,
    required this.errorMessage,
  });

  @override
  State<MoviesScreenTabs> createState() => _MoviesScreenTabsState();
}

class _MoviesScreenTabsState extends State<MoviesScreenTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  int chosenTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          labelStyle: Styles.labelMedium,
          unselectedLabelColor: secondaryTextColor,
          dividerColor: Colors.transparent,
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              chosenTabIndex = index;
            });
          },
        ),
        SizedBox(
          height: 16.h,
        ),
        BlocBuilder<FilterMoviesCubit, FilterMoviesState>(
          builder: (context, state) {
            final moviesList = chosenTabIndex == 0
                ? intersection([
                    state.searchedPopularMovies,
                    state.filteredPopularMovies,
                  ])
                : chosenTabIndex == 1
                    ? intersection([
                        state.searchedTopRatedMovies,
                        state.filteredTopRatedMovies,
                      ])
                    : intersection([
                        state.searchedUpcomingMovies,
                        state.filteredUpcomingMovies,
                      ]);
            final status = chosenTabIndex == 0
                ? widget.popularMoviesStatus
                : chosenTabIndex == 1
                    ? widget.topRatedMoviesStatus
                    : widget.upcomingMoviesStatus;
            return Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tabs.length,
                onPageChanged: (index) {
                  _tabController.animateTo(index);
                },
                itemBuilder: (context, index) {
                  return MoviesListing(
                    moviesList: moviesList,
                    genres: widget.genres,
                    isGridView: widget.gridView,
                    status: status,
                    errorMessage: widget.errorMessage.isNotEmpty
                        ? widget.errorMessage
                        : moviesList.isEmpty
                            ? 'No movies found. Change your filter or search criteria.'
                            : '',
                    allowRetry: status == MoviesStatus.failure,
                    onLoadNextPage: () {
                      context.read<MoviesCubit>().loadNextPage(
                            movieType: index == 0
                                ? MovieType.popular
                                : index == 1
                                    ? MovieType.topRated
                                    : MovieType.upcoming,
                          );
                    },
                    onRetry: () {
                      context.read<MoviesCubit>().getMoviesByType(
                            movieType: index == 0
                                ? MovieType.popular
                                : index == 1
                                    ? MovieType.topRated
                                    : MovieType.upcoming,
                          );
                      context.read<MoviesCubit>().getGenres();
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  List<T> intersection<T>(Iterable<Iterable<T>> iterables) {
    return iterables
        .map((e) => e.toSet())
        .reduce((a, b) => a.intersection(b))
        .toList();
  }
}

class MoviesListing extends StatelessWidget {
  final List<Movie> moviesList;
  final List<Genre> genres;
  final bool isGridView;
  final MoviesStatus status;
  final String errorMessage;
  final bool allowRetry;
  final Function() onLoadNextPage;
  final Function() onRetry;

  const MoviesListing({
    super.key,
    required this.moviesList,
    required this.genres,
    required this.isGridView,
    required this.status,
    required this.errorMessage,
    this.allowRetry = false,
    required this.onLoadNextPage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return status == MoviesStatus.loading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: primaryColor,
              ),
              SizedBox(
                height: 32.h,
              ),
              CustomButton(
                text: 'Retry',
                height: 48.h,
                width: 100.w,
                onPressed: () {
                  onRetry();
                },
              )
            ],
          )
        : status == MoviesStatus.failure
            ? ErrorMessageWidget(
                message: errorMessage,
                isEmpty: false,
                onRetry: onRetry,
              )
            : moviesList.isEmpty
                ? ErrorMessageWidget(
                    message: errorMessage,
                    isEmpty: true,
                  )
                : PaginationListWidget(
                    isGridView: isGridView,
                    itemCount: moviesList.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: moviesList[index],
                        isGridView: isGridView,
                        genres: genres,
                      );
                    },
                    loadNextPage: () async {
                      final List<ConnectivityResult> connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult[0] == ConnectivityResult.none) {
                        return;
                      }
                      if (status == MoviesStatus.loadingNextPage) return;
                      onLoadNextPage();
                    },
                    showLoadingIndicator:
                        status == MoviesStatus.loadingNextPage,
                  );
  }
}

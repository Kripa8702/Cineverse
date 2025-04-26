import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/features/movies/cubit/movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/widgets/movie_card.dart';
import 'package:solguruz_practical_task/features/widgets/error_message_widget.dart';
import 'package:solguruz_practical_task/features/widgets/pagination_list_widget.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

const List<String> _tabs = ["Popular", "Top Rated", "Upcoming"];

class MoviesScreenTabs extends StatefulWidget {
  const MoviesScreenTabs({super.key});

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

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
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
            setState(() {
              chosenTabIndex = index;
            });
          },
        ),
        SizedBox(
          height: 16.h,
        ),
        BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            final moviesList = chosenTabIndex == 0
                ? state.filteredPopularMovies
                : chosenTabIndex == 1
                    ? state.filteredTopRatedMovies
                    : state.filteredUpcomingMovies;
            final status = chosenTabIndex == 0
                ? state.popularMoviesStatus
                : chosenTabIndex == 1
                    ? state.topRatedMoviesStatus
                    : state.upcomingMoviesStatus;
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
                    genres: state.genres,
                    isGridView: state.gridView,
                    status: status,
                    errorMessage: state.errorMessage,
                    onLoadNextPage: () {
                      context.read<MoviesCubit>().loadNextPage(
                            movieType: index == 0
                                ? MovieType.popular
                                : index == 1
                                    ? MovieType.topRated
                                    : MovieType.upcoming,
                          );
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
}

class MoviesListing extends StatelessWidget {
  final List<Movie> moviesList;
  final List<Genre> genres;
  final bool isGridView;
  final MoviesStatus status;
  final String errorMessage;
  final Function() onLoadNextPage;

  const MoviesListing({
    super.key,
    required this.moviesList,
    required this.genres,
    required this.isGridView,
    required this.status,
    required this.errorMessage,
    required this.onLoadNextPage,
  });

  @override
  Widget build(BuildContext context) {
    return status == MoviesStatus.loading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : status == MoviesStatus.failure
            ? ErrorMessageWidget(
                message: errorMessage,
                isEmpty: moviesList.isEmpty,
                onRetry: () {
                  context.read<MoviesCubit>().initMovies(
                        movieType: isGridView
                            ? MovieType.popular
                            : isGridView
                                ? MovieType.topRated
                                : MovieType.upcoming,
                      );
                },
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
                loadNextPage: () {
                  if (status == MoviesStatus.loadingNextPage) return;
                  onLoadNextPage();
                },
                showLoadingIndicator: status == MoviesStatus.loadingNextPage,
              );
  }
}

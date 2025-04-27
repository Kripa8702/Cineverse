part of 'movies_cubit.dart';

enum MovieType { popular, topRated, upcoming }

enum MoviesStatus { loading, loadingNextPage, success, failure }

class MoviesState extends Equatable {
  const MoviesState({
    this.popularMoviesStatus = MoviesStatus.loading,
    this.topRatedMoviesStatus = MoviesStatus.loading,
    this.upcomingMoviesStatus = MoviesStatus.loading,
    this.fetchMovieDetailsStatus = MoviesStatus.loading,
    this.gridView = true,
    this.errorMessage = '',
    this.genres = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
    this.currentPopularPage = 1,
    this.currentTopRatedPage = 1,
    this.currentUpcomingPage = 1,
    this.totalPopularPages = 1,
    this.totalTopRatedPages = 1,
    this.totalUpcomingPages = 1,
  });

  final MoviesStatus popularMoviesStatus;
  final MoviesStatus topRatedMoviesStatus;
  final MoviesStatus upcomingMoviesStatus;
  final MoviesStatus fetchMovieDetailsStatus;

  final bool gridView;
  final String errorMessage;

  final List<Genre> genres;

  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;

  final int currentPopularPage;
  final int currentTopRatedPage;
  final int currentUpcomingPage;

  final int totalPopularPages;
  final int totalTopRatedPages;
  final int totalUpcomingPages;

  MoviesState copyWith({
    MoviesStatus? popularMoviesStatus,
    MoviesStatus? topRatedMoviesStatus,
    MoviesStatus? upcomingMoviesStatus,
    MoviesStatus? fetchMovieDetailsStatus,
    List<Genre>? genres,
    List<Genre>? selectedGenres,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    List<Movie>? filteredPopularMovies,
    List<Movie>? filteredTopRatedMovies,
    List<Movie>? filteredUpcomingMovies,
    bool? gridView,
    String? errorMessage,
    int? currentPopularPage,
    int? currentTopRatedPage,
    int? currentUpcomingPage,
    int? totalPopularPages,
    int? totalTopRatedPages,
    int? totalUpcomingPages,
  }) {
    return MoviesState(
      popularMoviesStatus: popularMoviesStatus ?? this.popularMoviesStatus,
      topRatedMoviesStatus: topRatedMoviesStatus ?? this.topRatedMoviesStatus,
      upcomingMoviesStatus: upcomingMoviesStatus ?? this.upcomingMoviesStatus,
      fetchMovieDetailsStatus:
          fetchMovieDetailsStatus ?? this.fetchMovieDetailsStatus,
      genres: genres ?? this.genres,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      gridView: gridView ?? this.gridView,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPopularPage: currentPopularPage ?? this.currentPopularPage,
      currentTopRatedPage: currentTopRatedPage ?? this.currentTopRatedPage,
      currentUpcomingPage: currentUpcomingPage ?? this.currentUpcomingPage,
      totalPopularPages: totalPopularPages ?? this.totalPopularPages,
      totalTopRatedPages: totalTopRatedPages ?? this.totalTopRatedPages,
      totalUpcomingPages: totalUpcomingPages ?? this.totalUpcomingPages,
    );
  }

  @override
  List<Object> get props => [
        popularMoviesStatus,
        topRatedMoviesStatus,
        upcomingMoviesStatus,
        fetchMovieDetailsStatus,
        genres,
        popularMovies,
        topRatedMovies,
        upcomingMovies,
        gridView,
        errorMessage,
        currentPopularPage,
        totalPopularPages
      ];
}

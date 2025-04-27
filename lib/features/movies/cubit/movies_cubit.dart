import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/exceptions/custom_exception.dart';
import 'package:solguruz_practical_task/features/movies/repository/movies_repository.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';
import 'package:solguruz_practical_task/services/hive_service.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit({required this.repository}) : super(const MoviesState());

  MoviesRepository repository;

  /// API call Methods
  Future<void> getGenres() async {
    try {
      final genresResponse = await repository.getAllGenres();
      emit(state.copyWith(
        genres: genresResponse,
      ));
    } on CustomException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
      ));
    }
  }

  Future<void> getMoviesByType({required MovieType movieType}) async {
    emit(state.copyWith(
      popularMoviesStatus:
          movieType == MovieType.popular ? MoviesStatus.loading : null,
      topRatedMoviesStatus:
          movieType == MovieType.topRated ? MoviesStatus.loading : null,
      upcomingMoviesStatus:
          movieType == MovieType.upcoming ? MoviesStatus.loading : null,
      selectedGenres: [],
    ));
    try {
      if (movieType == MovieType.popular) {
        final moviesResponse = await repository.getPopularMovies(page: 1);

        emit(state.copyWith(
          popularMoviesStatus: MoviesStatus.success,
          popularMovies: moviesResponse.results,
          currentPopularPage: 1,
          totalPopularPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.topRated) {
        final moviesResponse = await repository.getTopRatedMovies(page: 1);

        emit(state.copyWith(
          topRatedMoviesStatus: MoviesStatus.success,
          topRatedMovies: moviesResponse.results,
          currentTopRatedPage: 1,
          totalTopRatedPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.upcoming) {
        final moviesResponse = await repository.getUpcomingMovies(page: 1);

        emit(state.copyWith(
          upcomingMoviesStatus: MoviesStatus.success,
          upcomingMovies: moviesResponse.results,
          currentUpcomingPage: 1,
          totalUpcomingPages: moviesResponse.totalPages,
        ));
      }
    } on CustomException catch (e) {
      emit(state.copyWith(
        topRatedMoviesStatus: MoviesStatus.failure,
        upcomingMoviesStatus: MoviesStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> initData() async {
    await getMoviesByType(movieType: MovieType.popular);
    await getMoviesByType(movieType: MovieType.topRated);
    await getMoviesByType(movieType: MovieType.upcoming);
    await getGenres();
  }

  Future<void> loadNextPage({required MovieType movieType}) async {
    final currentState = state;
    final status = movieType == MovieType.popular
        ? currentState.popularMoviesStatus
        : movieType == MovieType.topRated
            ? currentState.topRatedMoviesStatus
            : currentState.upcomingMoviesStatus;
    final currentPage = movieType == MovieType.popular
        ? currentState.currentPopularPage
        : movieType == MovieType.topRated
            ? currentState.currentTopRatedPage
            : currentState.currentUpcomingPage;
    final totalPages = movieType == MovieType.popular
        ? currentState.totalPopularPages
        : movieType == MovieType.topRated
            ? currentState.totalTopRatedPages
            : currentState.totalUpcomingPages;

    if (status == MoviesStatus.loadingNextPage) return;
    if (currentPage >= totalPages) return;

    if (movieType == MovieType.popular) {
      emit(currentState.copyWith(
          popularMoviesStatus: MoviesStatus.loadingNextPage));
    } else if (movieType == MovieType.topRated) {
      emit(currentState.copyWith(
          topRatedMoviesStatus: MoviesStatus.loadingNextPage));
    } else if (movieType == MovieType.upcoming) {
      emit(currentState.copyWith(
          upcomingMoviesStatus: MoviesStatus.loadingNextPage));
    }

    try {
      if (movieType == MovieType.popular) {
        final moviesResponse = await repository.getPopularMovies(
            page: currentState.currentPopularPage + 1);

        emit(currentState.copyWith(
          popularMoviesStatus: MoviesStatus.success,
          popularMovies: [
            ...currentState.popularMovies,
            ...moviesResponse.results
          ],
          currentPopularPage: currentState.currentPopularPage + 1,
          totalPopularPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.topRated) {
        final moviesResponse = await repository.getTopRatedMovies(
            page: currentState.currentTopRatedPage + 1);

        emit(currentState.copyWith(
          topRatedMoviesStatus: MoviesStatus.success,
          topRatedMovies: [
            ...currentState.topRatedMovies,
            ...moviesResponse.results
          ],
          currentTopRatedPage: currentState.currentTopRatedPage + 1,
          totalTopRatedPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.upcoming) {
        final moviesResponse = await repository.getUpcomingMovies(
            page: currentState.currentUpcomingPage + 1);

        emit(currentState.copyWith(
          upcomingMoviesStatus: MoviesStatus.success,
          upcomingMovies: [
            ...currentState.upcomingMovies,
            ...moviesResponse.results
          ],
          currentUpcomingPage: currentState.currentUpcomingPage + 1,
          totalUpcomingPages: moviesResponse.totalPages,
        ));
      }
    } on CustomException catch (e) {
      emit(currentState.copyWith(
        popularMoviesStatus: MoviesStatus.failure,
        topRatedMoviesStatus: MoviesStatus.failure,
        upcomingMoviesStatus: MoviesStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  /// State modification and manipulation Methods
  void toggleGridView(bool isGridView) {
    emit(state.copyWith(gridView: isGridView));
  }

  Future<void> getMoviesFromCache() async {
    final cachedPopularMovies = await HiveService.getCachedPopularMovies();
    final cachedTopRatedMovies = await HiveService.getCachedTopRatedMovies();
    final cachedUpcomingMovies = await HiveService.getCachedUpcomingMovies();

    emit(state.copyWith(
      popularMovies: cachedPopularMovies,
      topRatedMovies: cachedTopRatedMovies,
      upcomingMovies: cachedUpcomingMovies,
      popularMoviesStatus: MoviesStatus.success,
      topRatedMoviesStatus: MoviesStatus.success,
      upcomingMoviesStatus: MoviesStatus.success,

    ));
  }

  Future<void> getGenresFromCache() async {
    final cachedGenres = await HiveService.getCachedGenres();

    emit(state.copyWith(genres: cachedGenres));
  }

  Future<void> initCacheData() async {
    await getMoviesFromCache();
    await getGenresFromCache();
  }
}

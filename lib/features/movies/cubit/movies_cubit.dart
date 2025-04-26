import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solguruz_practical_task/exceptions/custom_exception.dart';
import 'package:solguruz_practical_task/features/movies/repository/movies_repository.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit({required this.moviesRepository}) : super(const MoviesState());

  MoviesRepository moviesRepository;

  /// API call Methods
  Future<void> initGenres() async {
    try {
      final genresResponse = await moviesRepository.getAllGenres();
      emit(state.copyWith(
        genres: genresResponse,
      ));
    } on CustomException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
      ));
    }
  }

  Future<void> initMovies({required MovieType movieType}) async {
    emit(state.copyWith(popularMoviesStatus: MoviesStatus.loading));
    try {
      if (movieType == MovieType.popular) {
        final moviesResponse = await moviesRepository.getPopularMovies(page: 1);

        emit(state.copyWith(
          popularMoviesStatus: MoviesStatus.success,
          popularMovies: moviesResponse.results,
          filteredPopularMovies: moviesResponse.results,
          currentPopularPage: 1,
          totalPopularPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.topRated) {
        final moviesResponse =
            await moviesRepository.getTopRatedMovies(page: 1);

        emit(state.copyWith(
          topRatedMoviesStatus: MoviesStatus.success,
          topRatedMovies: moviesResponse.results,
          filteredTopRatedMovies: moviesResponse.results,
          currentTopRatedPage: 1,
          totalTopRatedPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.upcoming) {
        final moviesResponse =
            await moviesRepository.getUpcomingMovies(page: 1);

        emit(state.copyWith(
          upcomingMoviesStatus: MoviesStatus.success,
          upcomingMovies: moviesResponse.results,
          filteredUpcomingMovies: moviesResponse.results,
          currentUpcomingPage: 1,
          totalUpcomingPages: moviesResponse.totalPages,
        ));
      }
    } on CustomException catch (e) {
      emit(state.copyWith(
        popularMoviesStatus: MoviesStatus.failure,
        topRatedMoviesStatus: MoviesStatus.failure,
        upcomingMoviesStatus: MoviesStatus.failure,
        errorMessage: e.message,
      ));
    }
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
        final moviesResponse = await moviesRepository.getPopularMovies(
            page: currentState.currentPopularPage + 1);

        emit(currentState.copyWith(
          popularMoviesStatus: MoviesStatus.success,
          popularMovies: [
            ...currentState.popularMovies,
            ...moviesResponse.results
          ],
          filteredPopularMovies: [
            ...currentState.filteredPopularMovies,
            ...moviesResponse.results
          ],
          currentPopularPage: currentState.currentPopularPage + 1,
          totalPopularPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.topRated) {
        final moviesResponse = await moviesRepository.getTopRatedMovies(
            page: currentState.currentTopRatedPage + 1);

        emit(currentState.copyWith(
          topRatedMoviesStatus: MoviesStatus.success,
          topRatedMovies: [
            ...currentState.topRatedMovies,
            ...moviesResponse.results
          ],
          filteredTopRatedMovies: [
            ...currentState.filteredTopRatedMovies,
            ...moviesResponse.results
          ],
          currentTopRatedPage: currentState.currentTopRatedPage + 1,
          totalTopRatedPages: moviesResponse.totalPages,
        ));
      } else if (movieType == MovieType.upcoming) {
        final moviesResponse = await moviesRepository.getUpcomingMovies(
            page: currentState.currentUpcomingPage + 1);

        emit(currentState.copyWith(
          upcomingMoviesStatus: MoviesStatus.success,
          upcomingMovies: [
            ...currentState.upcomingMovies,
            ...moviesResponse.results
          ],
          filteredUpcomingMovies: [
            ...currentState.filteredUpcomingMovies,
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

  void searchMovies({required String query}) {
    if (query.isEmpty) {
      emit(state.copyWith(
        filteredPopularMovies: state.popularMovies,
        filteredTopRatedMovies: state.topRatedMovies,
        filteredUpcomingMovies: state.upcomingMovies,
        popularMoviesStatus: MoviesStatus.success,
        topRatedMoviesStatus: MoviesStatus.success,
        upcomingMoviesStatus: MoviesStatus.success,
      ));
      return;
    }
    final popularMovies = state.popularMovies
        .where(
            (movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final topRatedMovies = state.topRatedMovies
        .where(
            (movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final upcomingMovies = state.upcomingMovies
        .where(
            (movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(
      filteredPopularMovies: popularMovies,
      filteredTopRatedMovies: topRatedMovies,
      filteredUpcomingMovies: upcomingMovies,
      popularMoviesStatus:
          popularMovies.isEmpty ? MoviesStatus.failure : MoviesStatus.success,
      topRatedMoviesStatus:
          topRatedMovies.isEmpty ? MoviesStatus.failure : MoviesStatus.success,
      upcomingMoviesStatus:
          upcomingMovies.isEmpty ? MoviesStatus.failure : MoviesStatus.success,
      errorMessage: popularMovies.isEmpty ||
              topRatedMovies.isEmpty ||
              upcomingMovies.isEmpty
          ? "No movies found!"
          : "",
    ));
  }

  /// State modification Methods
  void toggleGridView(bool isGridView) {
    emit(state.copyWith(gridView: isGridView));
  }
}

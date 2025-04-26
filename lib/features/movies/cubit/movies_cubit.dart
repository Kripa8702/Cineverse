import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solguruz_practical_task/exceptions/custom_exception.dart';
import 'package:solguruz_practical_task/features/movies/repository/movies_repository.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit({required this.moviesRepository}) : super(const MoviesState());

  MoviesRepository moviesRepository;

  /// API call Methods
  Future<void> initPopularMovies() async {
    emit(state.copyWith(status: MoviesStatus.loading));
    try {
      final moviesResponse = await moviesRepository.getPopularMovies(
        page: 1
      );

      emit(state.copyWith(
        status: MoviesStatus.success,
        popularMovies: moviesResponse.results,
        currentPage: 1,
        totalPages: moviesResponse.totalPages,
      ));
    } on CustomException catch (e) {
      emit(state.copyWith(
        status: MoviesStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> loadNextPopularMoviesPage() async {
    final currentState = state;
    if (currentState.status == MoviesStatus.loadingNextPage) return;
    if (currentState.currentPage >= currentState.totalPages) return;

    emit(
      currentState.copyWith(
        status: MoviesStatus.loadingNextPage,
      ),
    );

    try {
      final moviesResponse = await moviesRepository.getPopularMovies(
        page: currentState.currentPage + 1,
      );

      emit(
        currentState.copyWith(
          status: MoviesStatus.success,
          popularMovies: currentState.popularMovies + moviesResponse.results,
          currentPage: currentState.currentPage + 1,
        ),
      );
    } on CustomException catch (e) {
      emit(state.copyWith(
        status: MoviesStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  /// State modification Methods
  void toggleGridView() {
    emit(state.copyWith(gridView: !state.gridView));
  }
}

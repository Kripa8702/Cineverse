import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solguruz_practical_task/exceptions/custom_exception.dart';
import 'package:solguruz_practical_task/features/movies/repository/movies_repository.dart';
import 'package:solguruz_practical_task/models/movie_details_model.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit({required this.repository}) : super(const MovieDetailsState());

  MoviesRepository repository;

  Future<void> getMovieDetails({required int movieId}) async {
    emit(state.copyWith(status: MovieDetailsStatus.loading));
    try {
      final movieDetails = await repository.getMovieDetails(movieId: movieId);
      emit(state.copyWith(
        status: MovieDetailsStatus.success,
        movieDetails: movieDetails,
      ));
    } on CustomException catch (e) {
      emit(state.copyWith(
        status: MovieDetailsStatus.failure,
        errorMessage: e.message,
        movieDetails: null
      ));
    }
  }
}

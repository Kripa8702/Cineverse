part of 'movie_details_cubit.dart';

enum MovieDetailsStatus { loading, success, failure }

class MovieDetailsState extends Equatable {
  const MovieDetailsState({
    this.status = MovieDetailsStatus.loading,
    this.movieDetails,
    this.errorMessage = '',
  });

  final MovieDetailsStatus status;
  final MovieDetails? movieDetails;
  final String errorMessage;

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    MovieDetails? movieDetails,
    String? errorMessage,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      movieDetails: movieDetails, // null if no new data
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movieDetails, errorMessage];
}

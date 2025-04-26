part of 'movies_cubit.dart';

enum MoviesStatus { loading, loadingNextPage, success, failure }

class MoviesState extends Equatable {
  const MoviesState({
    this.status = MoviesStatus.loading,
    this.gridView = true,
    this.errorMessage = '',
    this.popularMovies = const [],
    this.currentPage = 1,
    this.totalPages = 1,
  });

  final MoviesStatus status;
  final bool gridView;
  final String errorMessage;

  final List<Movie> popularMovies;
  final int currentPage;
  final int totalPages;

  MoviesState copyWith({
    MoviesStatus? status,
    List<Movie>? popularMovies,
    bool? gridView,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
  }) {
    return MoviesState(
      status: status ?? this.status,
      popularMovies: popularMovies ?? this.popularMovies,
      gridView: gridView ?? this.gridView,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object> get props =>
      [status, popularMovies, gridView, errorMessage, currentPage, totalPages];
}

part of 'filter_movies_cubit.dart';

class FilterMoviesState extends Equatable {
  const FilterMoviesState({
    this.selectedGenres = const [],
    this.searchText = '',
    this.allPopularMovies = const [],
    this.allTopRatedMovies = const [],
    this.allUpcomingMovies = const [],
    this.searchedPopularMovies = const [],
    this.searchedTopRatedMovies = const [],
    this.searchedUpcomingMovies = const [],
    this.filteredPopularMovies = const [],
    this.filteredTopRatedMovies = const [],
    this.filteredUpcomingMovies = const [],
  });

  final List<Genre> selectedGenres;
  final String searchText;

  final List<Movie> allPopularMovies;
  final List<Movie> allTopRatedMovies;
  final List<Movie> allUpcomingMovies;

  final List<Movie> searchedPopularMovies;
  final List<Movie> searchedTopRatedMovies;
  final List<Movie> searchedUpcomingMovies;

  final List<Movie> filteredPopularMovies;
  final List<Movie> filteredTopRatedMovies;
  final List<Movie> filteredUpcomingMovies;

  FilterMoviesState copyWith({
    List<Genre>? selectedGenres,
    String? searchText,
    List<Movie>? allPopularMovies,
    List<Movie>? allTopRatedMovies,
    List<Movie>? allUpcomingMovies,
    List<Movie>? searchedPopularMovies,
    List<Movie>? searchedTopRatedMovies,
    List<Movie>? searchedUpcomingMovies,
    List<Movie>? filteredPopularMovies,
    List<Movie>? filteredTopRatedMovies,
    List<Movie>? filteredUpcomingMovies,
  }) {
    return FilterMoviesState(
      selectedGenres: selectedGenres ?? this.selectedGenres,
      searchText: searchText ?? this.searchText,
      allPopularMovies: allPopularMovies ?? this.allPopularMovies,
      allTopRatedMovies: allTopRatedMovies ?? this.allTopRatedMovies,
      allUpcomingMovies: allUpcomingMovies ?? this.allUpcomingMovies,
      searchedPopularMovies: searchedPopularMovies ?? this.searchedPopularMovies,
      searchedTopRatedMovies: searchedTopRatedMovies ?? this.searchedTopRatedMovies,
      searchedUpcomingMovies: searchedUpcomingMovies ?? this.searchedUpcomingMovies,
      filteredPopularMovies: filteredPopularMovies ?? this.filteredPopularMovies,
      filteredTopRatedMovies: filteredTopRatedMovies ?? this.filteredTopRatedMovies,
      filteredUpcomingMovies: filteredUpcomingMovies ?? this.filteredUpcomingMovies,
    );
  }

  @override
  List<Object> get props => [
        selectedGenres,
        searchText,
        searchedPopularMovies,
        searchedTopRatedMovies,
        searchedUpcomingMovies,
        filteredPopularMovies,
        filteredTopRatedMovies,
        filteredUpcomingMovies,
      ];

}

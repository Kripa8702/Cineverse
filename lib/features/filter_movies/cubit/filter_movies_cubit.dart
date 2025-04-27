import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';

part 'filter_movies_state.dart';

class FilterMoviesCubit extends Cubit<FilterMoviesState> {
  FilterMoviesCubit() : super(const FilterMoviesState());

  void initMovies({
    List<Movie>? popularMovies,
     List<Movie>? topRatedMovies,
     List<Movie>? upcomingMovies,
  }) {
    emit(state.copyWith(
      allPopularMovies: popularMovies,
      allTopRatedMovies: topRatedMovies,
      allUpcomingMovies: upcomingMovies,
      searchedPopularMovies: popularMovies,
      searchedTopRatedMovies: topRatedMovies,
      searchedUpcomingMovies: upcomingMovies,
      filteredPopularMovies: popularMovies,
      filteredTopRatedMovies: topRatedMovies,
      filteredUpcomingMovies: upcomingMovies,
    ));
    if(state.selectedGenres.isNotEmpty) {
      filterMoviesByGenres(state.selectedGenres);
    }
    if(state.searchText.isNotEmpty) {
      searchMovies(state.searchText);
    }
  }

  void searchMovies(String searchText) {
    emit(state.copyWith(searchText: searchText));

    if (searchText.isEmpty) {
      emit(state.copyWith(
        searchedPopularMovies: state.allPopularMovies,
        searchedTopRatedMovies: state.allTopRatedMovies,
        searchedUpcomingMovies: state.allUpcomingMovies,
      ));
      return;
    }
    final searchedPopular = state.allPopularMovies
        .where((movie) =>
            movie.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    final searchedTopRated = state.allTopRatedMovies
        .where((movie) =>
            movie.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    final searchedUpcoming = state.allUpcomingMovies
        .where((movie) =>
            movie.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    emit(state.copyWith(
      searchedPopularMovies: searchedPopular,
      searchedTopRatedMovies: searchedTopRated,
      searchedUpcomingMovies: searchedUpcoming,
    ));
  }

  void filterMoviesByGenres(List<Genre> selectedGenres) {
    emit(state.copyWith(selectedGenres: selectedGenres));

    if (selectedGenres.isEmpty) {
      emit(state.copyWith(
        filteredPopularMovies: state.allPopularMovies,
        filteredTopRatedMovies: state.allTopRatedMovies,
        filteredUpcomingMovies: state.allUpcomingMovies,
      ));
      return;
    }
    final filteredPopular = state.allPopularMovies
        .where((movie) => movie.genreIds.any(
            (genreId) => selectedGenres.any((genre) => genre.id == genreId)))
        .toList();
    final filteredTopRated = state.allTopRatedMovies
        .where((movie) => movie.genreIds.any(
            (genreId) => selectedGenres.any((genre) => genre.id == genreId)))
        .toList();
    final filteredUpcoming = state.allUpcomingMovies
        .where((movie) => movie.genreIds.any(
            (genreId) => selectedGenres.any((genre) => genre.id == genreId)))
        .toList();

    emit(state.copyWith(
      filteredPopularMovies: filteredPopular,
      filteredTopRatedMovies: filteredTopRated,
      filteredUpcomingMovies: filteredUpcoming,
    ));
  }
}

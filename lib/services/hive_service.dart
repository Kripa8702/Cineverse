import 'package:hive_flutter/hive_flutter.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/models/hive_models/hive_genre_model.dart';
import 'package:solguruz_practical_task/models/hive_models/hive_movie_model.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';
import 'package:solguruz_practical_task/utils/colored_logs.dart';

const String popularMoviesBox = 'popular_movies';
const String topRatedMoviesBox = 'top_rated_movies';
const String upcomingMoviesBox = 'upcoming_movies';
const String genreBox = 'genres';

class HiveService {
  static openHiveMoviesBox() async {
    ColoredLogs.hiveLog(":::::::: Opening Hive movies boxs ::::::::::");

    await Hive.openBox<HiveMovie>(popularMoviesBox);
    await Hive.openBox<HiveMovie>(topRatedMoviesBox);
    await Hive.openBox<HiveMovie>(upcomingMoviesBox);
    await Hive.openBox<HiveGenre>(genreBox);
  }

  /// Genres
  static Future<void> cacheGenres(List<Genre> genres) async {
    try {
      ColoredLogs.hiveLog(
          ":::::::: Caching genres in Hive: ${genres.length} ::::::::");
      final box = Hive.box<HiveGenre>(genreBox);
      await box.clear();

      await box.putAll(
        {for (var genre in genres) genre.id: genre.toHiveModel()},
      );
    } catch (e) {
      ColoredLogs.error("Error caching genres: $e");
    }
  }

  static Future<List<Genre>> getCachedGenres() async {
    try {
      final box = Hive.box<HiveGenre>(genreBox);
      final genres =
          box.values.map((hiveGenre) => hiveGenre.toGenre()).toList();
      ColoredLogs.hiveLog(
          "::::::::  Getting genres from Hive: ${genres.length} ::::::::");
      return genres;
    } catch (e) {
      ColoredLogs.error("Error getting genres from Hive: $e");
      return [];
    }
  }

  /// Popular movies
  static Future<void> cachePopularMovies(List<Movie> movies) async {
    try {
      ColoredLogs.hiveLog(
          ":::::::: Caching popular movies in Hive: ${movies.length} ::::::::");
      final box = Hive.box<HiveMovie>(popularMoviesBox);
      await box.clear();

      await box.putAll(
        {for (var movie in movies) movie.id: movie.toHiveMovie()},
      );
    } catch (e) {
      ColoredLogs.error("Error caching popular movies: $e");
    }
  }

  static Future<List<Movie>> getCachedPopularMovies() async {
    try {
      final box = Hive.box<HiveMovie>(popularMoviesBox);
      final movies =
          box.values.map((hiveMovie) => hiveMovie.toMovie()).toList();
      ColoredLogs.hiveLog(
          "::::::::  Getting popular movies from Hive: ${movies.length} ::::::::");
      return movies;
    } catch (e) {
      ColoredLogs.error("Error getting popular movies from Hive: $e");
      return [];
    }
  }

  /// Top Rated
  static Future<void> cacheTopRatedMovies(List<Movie> movies) async {
    try {
      ColoredLogs.hiveLog(
          ":::::::: Caching top rated movies in Hive: ${movies.length} ::::::::");
      final box = Hive.box<HiveMovie>(topRatedMoviesBox);
      await box.clear();

      await box.putAll(
        {for (var movie in movies) movie.id: movie.toHiveMovie()},
      );
    } catch (e) {
      ColoredLogs.error("Error caching top rated movies: $e");
    }
  }

  static Future<List<Movie>> getCachedTopRatedMovies() async {
    final box = Hive.box<HiveMovie>(topRatedMoviesBox);
    final movies = box.values.map((hiveMovie) => hiveMovie.toMovie()).toList();
    ColoredLogs.hiveLog(
        "::::::::  Getting top rated movies from Hive: ${movies.length} ::::::::");
    return movies;
  }

  /// Upcoming
  static Future<void> cacheUpcomingMovies(List<Movie> movies) async {
    try {
      ColoredLogs.hiveLog(
          ":::::::: Caching upcoming movies in Hive: ${movies.length} ::::::::");
      final box = Hive.box<HiveMovie>(topRatedMoviesBox);
      await box.clear();

      await box.putAll(
        {for (var movie in movies) movie.id: movie.toHiveMovie()},
      );
    } catch (e) {
      ColoredLogs.error("Error caching upcoming movies: $e");
    }
  }

  static Future<List<Movie>> getCachedUpcomingMovies() async {
    try {
      final box = Hive.box<HiveMovie>(topRatedMoviesBox);
      final movies =
          box.values.map((hiveMovie) => hiveMovie.toMovie()).toList();
      ColoredLogs.hiveLog(
          "::::::::  Getting upcoming movies from Hive: ${movies.length} ::::::::");
      return movies;
    } catch (e) {
      ColoredLogs.error("Error getting upcoming movies from Hive: $e");
      return [];
    }
  }
}

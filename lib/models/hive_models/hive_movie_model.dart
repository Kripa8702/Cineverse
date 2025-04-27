import 'package:hive/hive.dart';
import 'package:solguruz_practical_task/models/movie_model.dart';

part 'hive_movie_model.g.dart';

@HiveType(typeId: 0)
class HiveMovie extends HiveObject {
  HiveMovie({
    required this.id,
    required this.imagePath,
    required this.originalTitle,
    required this.title,
    required this.overview,
    required this.genreIds,
    required this.releaseDate,
    required this.backdropPath,
    required this.posterPath,
    required this.voteAverage,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String originalTitle;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String overview;

  @HiveField(5)
  final List<int> genreIds;

  @HiveField(6)
  final DateTime releaseDate;

  @HiveField(7)
  final String backdropPath;

  @HiveField(8)
  final String posterPath;

  @HiveField(9)
  final double voteAverage;
}

extension HiveMovieMapper on Movie {
  HiveMovie toHiveMovie() {
    return HiveMovie(
      id: id,
      imagePath: imagePath,
      originalTitle: originalTitle,
      title: title,
      overview: overview,
      genreIds: genreIds,
      releaseDate: releaseDate,
      backdropPath: backdropPath,
      posterPath: posterPath,
      voteAverage: voteAverage,
    );
  }
}

extension MovieMapper on HiveMovie {
  Movie toMovie() {
    return Movie(
      id: id,
      imagePath: imagePath,
      originalTitle: originalTitle,
      title: title,
      overview: overview,
      genreIds: genreIds,
      releaseDate: releaseDate,
      backdropPath: backdropPath,
      posterPath: posterPath,
      voteAverage: voteAverage,
    );
  }
}



import 'package:solguruz_practical_task/constants/api_path.dart';

///"genre_ids": [
//                 28,
//                 27,
//                 53
//             ],
class Movie {
  Movie({
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

  final int id;
  final String imagePath;
  final String originalTitle;
  final String title;
  final String overview;
  final List<int> genreIds;
  final DateTime releaseDate;
  final String backdropPath;
  final String posterPath;
  final double voteAverage;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"] ?? 0,
        imagePath: json["image_path"] ?? "",
        originalTitle: json["original_title"] ?? "",
        title: json["title"] ?? "",
        overview: json["overview"] ?? "",
        genreIds: json["genre_ids"] == null
            ? []
            : List<int>.from(json["genre_ids"].map((x) => x)),
        releaseDate: json["release_date"] == null
            ? DateTime.now()
            : DateTime.parse(json["release_date"]),
        backdropPath: "${ApiPath.imageBaseUrl}${json["backdrop_path"] ?? ""}",
        posterPath: "${ApiPath.imageBaseUrl}${json["poster_path"] ?? ""}",
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
      );
}

class Movie {
  Movie({
    required this.id,
    required this.imagePath,
    required this.originalTitle,
    required this.title,
    required this.overview,
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
  final String releaseDate;
  final String backdropPath;
  final String posterPath;
  final double voteAverage;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"] ?? 0,
        imagePath: json["image_path"] ?? "",
        originalTitle: json["original_title"] ?? "",
        title: json["title"] ?? "",
        overview: json["overview"] ?? "",
        releaseDate: json["release_date"] ?? "",
        backdropPath: json["backdrop_path"] ?? "",
        posterPath: json["poster_path"] ?? "",
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
      );
}
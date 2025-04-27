import 'package:solguruz_practical_task/constants/api_path.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';

class MovieDetails {
  final int id;
  final String posterPath;
  final String backdropPath;
  final String overview;
  final double popularity;
  final DateTime releaseDate;
  final String status;
  final String tagline;
  final String title;
  final double voteAverage;
  final int voteCount;
  final List<ProductionCompanies> productionCompanies;
  final List<Genre> genres;
  final double runTime;

  MovieDetails({
    required this.id,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.status,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.productionCompanies,
    required this.genres,
    this.runTime = 0,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'] ?? 0,
      posterPath: json['poster_path'] == null
          ? ""
          : "${ApiPath.imageBaseUrl}${json['poster_path']}",
      backdropPath: json['backdrop_path'] == null
          ? ""
          : "${ApiPath.imageBaseUrl}${json['backdrop_path']}",
      overview: json['overview'] ?? "",
      popularity: (json['popularity'] ?? 0).toDouble(),
      releaseDate: json['release_date'] == null
          ? DateTime.now()
          : DateTime.parse(json['release_date']),
      status: json['status'] ?? "",
      tagline: json['tagline'] ?? "",
      title: json['title'] ?? "",
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      productionCompanies: json['production_companies'] == null
          ? []
          : List<ProductionCompanies>.from(
              json['production_companies']
                  .map((x) => ProductionCompanies.fromJson(x)),
            ),
      genres: json['genres'] == null
          ? []
          : List<Genre>.from(
              json['genres'].map((x) => Genre.fromJson(x)),
            ),
      runTime: (json['runtime'] ?? 0).toDouble(),
    );
  }
}

class ProductionCompanies {
  final int id;
  final String logoPath;
  final String name;
  final String originCountry;

  ProductionCompanies({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompanies.fromJson(Map<String, dynamic> json) {
    return ProductionCompanies(
      id: json['id'] ?? 0,
      logoPath: json['logo_path'] == null
          ? ""
          : "${ApiPath.imageBaseUrl}${json['logo_path']}",
      name: json['name'] ?? "",
      originCountry: json['origin_country'] ?? "",
    );
  }
}

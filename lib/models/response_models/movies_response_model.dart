import 'package:solguruz_practical_task/models/movie_model.dart';

class MoviesResponseModel {
  MoviesResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) =>
      MoviesResponseModel(
        page: json["page"] ?? 0,
        results: json["results"] == null
            ? []
            : List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"] ?? 0,
        totalResults: json["total_results"] ?? 0,
      );
}

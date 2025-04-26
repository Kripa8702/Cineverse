import 'package:solguruz_practical_task/constants/api_path.dart';
import 'package:solguruz_practical_task/exceptions/custom_exception.dart';
import 'package:solguruz_practical_task/models/response_models/movies_response_model.dart';
import 'package:solguruz_practical_task/utils/dio_client.dart';

class MoviesRepository{
MoviesRepository({
  required DioClient dioClient,
}) : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<MoviesResponseModel> getPopularMovies({required int page}) async {
    try {
      final response = await _dioClient.get(
        "${ApiPath.popularMovies}?language=en-US&page=$page",
      );
      final moviesResponse = MoviesResponseModel.fromJson(response);
      if (moviesResponse.results.isEmpty) {
        throw CustomException("No movies found! Please try again later.");
      }
      return moviesResponse;
    } on CustomException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw CustomException("Something went wrong, please try again later.");
    }
  }
}
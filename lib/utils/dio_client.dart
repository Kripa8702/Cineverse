import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solguruz_practical_task/constants/api_path.dart';
import 'package:solguruz_practical_task/exceptions/custom_exception.dart';
import 'package:solguruz_practical_task/utils/colored_logs.dart';
import 'package:dio/dio.dart';

class DioClient {
  Dio _dio = Dio();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiPath.baseUrl,
    ));

    _dio.options.headers = headers;
  }

  Map<String, String> get headers {
    final authToken = dotenv.env['AUTH_TOKEN'] ?? '';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    return headers;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
    String? customInvalidDataMessage,
  }) async {
    try {
      ColoredLogs.debug(
          "<----- Request: $endpoint \n Body: $queryParameters \n Headers: ${headers..addAll(extraHeaders ?? {})}");

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headers..addAll(extraHeaders ?? {}),
        ),
      );

      ColoredLogs.debug("\n-----> $endpoint Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 500) {
        throw CustomException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw CustomException(response.data["message"],
            status: response.statusCode);
      }
    } on CustomException catch (e) {
      ColoredLogs.error(e.message);
      throw CustomException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? extraHeaders,
    String? customInvalidDataMessage,
    String? customNotFoundMessage,
  }) async {
    try {
      ColoredLogs.debug(
          "<----- Request: $endpoint \n Body: $data \n Headers:  ${headers..addAll(extraHeaders ?? {})}");

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: headers..addAll(extraHeaders ?? {}),
        ),
      );

      ColoredLogs.debug("\n-----> $endpoint Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        /// Common Response is the based on the accepted response format from the server side. It is changed here to accommodate dummy API response
        /// Comment the below lines to use this response format
        // final res = CommonResponse.fromJson(response.data);
        // if (!res.success) {
        //   throw ApiException(res.message, status: response.statusCode);
        // }
        // return res.data;

        /// And remove the below line
        return response.data;
      } else if (response.statusCode == 500) {
        throw CustomException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw CustomException(response.data["message"],
            status: response.statusCode);
      }
    } on CustomException catch (e) {
      ColoredLogs.error(e.message);
      throw CustomException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      ColoredLogs.debug("<----- Request: $endpoint \n Body: $data");

      final response = await _dio.put(endpoint, data: data);

      ColoredLogs.debug("\n-----> Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 500) {
        throw CustomException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw CustomException(response.data["message"],
            status: response.statusCode);
      }
    } on CustomException catch (e) {
      ColoredLogs.error(e.message);
      throw CustomException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      ColoredLogs.debug("<----- Request: $endpoint");

      final response = await _dio.delete(endpoint);

      ColoredLogs.debug("\n-----> Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 500) {
        throw CustomException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw CustomException(response.data["message"],
            status: response.statusCode);
      }
    } on CustomException catch (e) {
      ColoredLogs.error(e.message);
      throw CustomException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }
}

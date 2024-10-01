import 'package:alfacycle/models/base_response.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://your_domain',
  ));

  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic json) fromJsonT,
  }) async {
    final updatedHeaders = {
      ...?headers,
      'Content-Type': 'application/json',
    };

    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: updatedHeaders),
    );

    return _processResponse<T>(
      response: response,
      fromJson: fromJsonT,
    );
  }

  Future<T> post<T>({
    required String path,
    required Map<String, dynamic> body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJsonT,
  }) async {
    final updatedHeaders = {
      ...?headers,
      'Content-Type': 'application/json',
    };

    final response = await _dio.post(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: updatedHeaders),
    );

    return _processResponse<T>(
      response: response,
      fromJson: fromJsonT,
    );
  }

  T _processResponse<T>({
    required Response response,
    required T Function(dynamic json) fromJson,
  }) {
    if (response.statusCode == 200) {
      final dynamic jsonObject = response.data;

      if (jsonObject is Map<String, dynamic>) {
          return fromJson(jsonObject);
      }
      throw ('Unexpected response format.');
    } else {
      throw ('HTTP error, code: ${response.statusCode}');
    }
  }
}

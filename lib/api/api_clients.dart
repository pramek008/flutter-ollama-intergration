import 'package:dio/dio.dart';

enum RequestType { get, post, put, patch, delete }

class DioClients {
  final Dio _dio = Dio();

  Dio get dio => _dio;

  DioClients() {
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    ]);
  }

  Future<Response> request({
    required String path,
    required RequestType requestType,
    Map<String, String>? header,
    Map<String, dynamic>? queryParameters,
    RequestOptions? options,
    dynamic data,
  }) async {
    late Response response;
    try {
      switch (requestType) {
        case RequestType.get:
          {
            Options options = Options(headers: header);
            response = await _dio.get(
              path,
              queryParameters: queryParameters,
              options: options,
            );
            break;
          }
        case RequestType.post:
          {
            Options options = Options(headers: header);
            response = await _dio.post(
              path,
              data: data,
              options: options,
            );
            break;
          }
        case RequestType.put:
          {
            Options options = Options(headers: header);
            response = await _dio.put(
              path,
              data: data,
              options: options,
            );
            break;
          }
        case RequestType.patch:
          {
            Options options = Options(headers: header);
            response = await _dio.patch(
              path,
              data: data,
              options: options,
            );
            break;
          }
        case RequestType.delete:
          {
            Options options = Options(headers: header);
            response = await _dio.delete(
              path,
              data: data,
              options: options,
            );
            break;
          }
      }
    } on DioException catch (e) {
      throw e;
    }
    return response;
  }
}

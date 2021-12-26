import 'package:dio/dio.dart';

class DioErrorGenerator {
  static DioError notFound() {
    return _generateDioError(404);
  }

  static DioError unauthorized() {
    return _generateDioError(401);
  }

  static DioError _generateDioError(int statusCode) {
    RequestOptions requestOptions = RequestOptions(path: '/');
    DioError dioError = DioError(
        requestOptions: RequestOptions(path: '/'),
        error: statusCode,
        response:
            Response(requestOptions: requestOptions, statusCode: statusCode));
    return dioError;
  }
}

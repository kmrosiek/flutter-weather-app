import 'package:dio/dio.dart';
/*
class DioErrorResponse {
  final DioError _dioError;

  static const notFoundCode = 404;
  static const unauthorizedCode = 401;

  DioError get dioError => _dioError;

  DioErrorResponse(this._dioError);

  factory DioErrorResponse._create(int statusCode) {
    RequestOptions requestOptions = RequestOptions(path: '/');
    DioError dioError = DioError(
        requestOptions: RequestOptions(path: '/'),
        error: statusCode,
        response:
            Response(requestOptions: requestOptions, statusCode: statusCode));
    return DioErrorResponse(dioError);
  }

  factory DioErrorResponse.notFound() {
    return DioErrorResponse._create(notFoundCode);
  }

  factory DioErrorResponse.unauthorized() {
    return DioErrorResponse._create(unauthorizedCode);
  }
}*/

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

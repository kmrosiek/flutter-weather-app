import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:weatherapp/domain/core/network_info.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/infrastructure/core/http_exceptions.dart';
import 'package:weatherapp/infrastructure/data_models/coordinates_dto.dart';

@LazySingleton(as: IRemoteRepository)
class OpenWeatherRepository implements IRemoteRepository {
  final INetworkInfo networkInfo;
  final IAPIClient apiClient;

  OpenWeatherRepository({required this.networkInfo, required this.apiClient});
  @override
  Future<Either<RepositoryFailure, Weather>> getDataForCity(String city) async {
    if (!await networkInfo.isConnected) {
      return left(const RepositoryFailure.noInternet());
    }

    Coordinates coords;
    try {
      coords =
          await apiClient.getCityCoordinates(city).catchError((Object obj) {
        throw ResponseException(obj);
      });
    } on ResponseException catch (e) {
      return left(handleException(e.object));
    }

    return Future.value(left(const RepositoryFailure.notFound()));
  }

  RepositoryFailure handleException(Object obj) {
    if (obj.runtimeType == DioError) {
      final response = (obj as DioError).response;
      switch (response?.statusCode) {
        case 401:
        case 403:
          return const RepositoryFailure.insufficientPermission();
        case 404:
          return const RepositoryFailure.notFound();
      }
    }
    return const RepositoryFailure.unexpected();
  }
}

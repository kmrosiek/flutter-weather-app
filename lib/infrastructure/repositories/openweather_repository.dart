import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:weatherapp/domain/core/network_info.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/infrastructure/data_models/coordinates_dto.dart';
import 'package:weatherapp/infrastructure/data_models/weather_dto.dart';

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

    final WeatherDto weatherDto;

    try {
      final Coordinates coords =
          await apiClient.getCityCoordinates(city).catchError((Object error) {
        throw error;
      });

      weatherDto = await apiClient
          .getWeather(coords.coord.latitude, coords.coord.longitude)
          .catchError((Object error) {
        throw error;
      });
    } on DioError catch (dioError) {
      final response = dioError.response;
      switch (response?.statusCode) {
        case 401:
        case 403:
          return left(const RepositoryFailure.insufficientPermission());
        case 404:
          return left(const RepositoryFailure.notFound());
      }
      return left(const RepositoryFailure.unexpected());
    } on TypeError catch (_) {
      return left(const RepositoryFailure.invalidDatabaseStructure());
    } on RangeError catch (_) {
      return left(const RepositoryFailure.invalidDatabaseStructure());
    }

    var weather = weatherDto.toDomain();
    if (!weather.isValid) {
      return left(const RepositoryFailure.invalidArgument());
    }

    return right(weatherDto.toDomain());
  }
}

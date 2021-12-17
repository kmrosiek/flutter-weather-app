import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:weatherapp/domain/core/network_info.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

@LazySingleton(as: IRemoteRepository)
class OpenWeatherRepository implements IRemoteRepository {
  final INetworkInfo networkInfo;

  OpenWeatherRepository({required this.networkInfo});
  @override
  Future<Either<RepositoryFailure, Weather>> getDataForCity(String city) async {
    if (!await networkInfo.isConnected) {
      return left(const RepositoryFailure.noInternet());
    }
    return Future.value(left(const RepositoryFailure.notFound()));
  }
}

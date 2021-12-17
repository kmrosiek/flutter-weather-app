import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

abstract class IRemoteRepository {
  Future<Either<RepositoryFailure, Weather>> getDataForCity(String city);
}

import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/data_models/value_objects.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

abstract class ILocalRepository {
  Future<Either<RepositoryFailure, Unit>> saveCity(CityName cityName);
  Future<Either<RepositoryFailure, List<CityName>>> loadCityList();
}

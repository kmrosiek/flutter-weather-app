import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/data_models/city_name_and_favorite.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

abstract class ILocalRepository {
  Future<Either<RepositoryFailure, Unit>> saveCity(
      CityNameAndFavorite cityNameAndFavorite);
  Future<Either<RepositoryFailure, Unit>> deleteCity(
      CityNameAndFavorite cityNameAndFavorite);
  Future<Either<RepositoryFailure, List<CityNameAndFavorite>>> loadCityList();
}

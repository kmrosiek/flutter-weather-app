import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/domain/data_models/city_name_and_favorite.dart';
import 'package:weatherapp/domain/repositories/i_local_repository.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

@LazySingleton(as: ILocalRepository)
class SharedPrefRepository implements ILocalRepository {
  final SharedPreferences sharedPreferences;
  static const cachedCityList = "CACHED_CITY_LIST";

  SharedPrefRepository(this.sharedPreferences);

  @override
  Future<Either<RepositoryFailure, List<CityNameAndFavorite>>>
      loadCitySet() async {
    List<String>? cityList;
    try {
      cityList = sharedPreferences.getStringList(cachedCityList);
    } on TypeError catch (_) {
      return Future.value(
          const Left(RepositoryFailure.invalidDatabaseStructure()));
    }

    if (cityList == null || cityList.isEmpty) {
      return Future.value(const Left(RepositoryFailure.notFound()));
    }

    final List<CityNameAndFavorite> citiesNameAndFavorite;
    try {
      citiesNameAndFavorite = cityList
          .map((city) => CityNameAndFavorite.fromJson(jsonDecode(city)))
          .toList();
    } on FormatException catch (_) {
      return Future.value(
          const Left(RepositoryFailure.invalidDatabaseStructure()));
    } on TypeError catch (_) {
      return Future.value(
          const Left(RepositoryFailure.invalidDatabaseStructure()));
    }

    return Future.value(right(citiesNameAndFavorite));
  }

  @override
  Future<Either<RepositoryFailure, Unit>> saveCity(
      CityNameAndFavorite cityNameAndFavorite) async {
    var cityNamesOrFailure = await loadCitySet();

    return Future.value(cityNamesOrFailure.fold((failure) async {
      if (const RepositoryFailure.notFound() == failure) {
        await saveListWithLowerCase([cityNameAndFavorite]);
        return right(unit);
      }
      return left(failure);
    }, (citiesNamesAndFavorite) {
      final int sameCityIndex = citiesNamesAndFavorite.indexWhere((element) =>
          element.cityName == cityNameAndFavorite.cityName.toLowerCase());

      sameCityIndex == -1
          ? citiesNamesAndFavorite.add(cityNameAndFavorite)
          : citiesNamesAndFavorite[sameCityIndex] = cityNameAndFavorite;

      saveListWithLowerCase(citiesNamesAndFavorite);
      return right(unit);
    }));
  }

  Future<void> saveListWithLowerCase(
      List<CityNameAndFavorite> citiesNamesAndFavorite) async {
    sharedPreferences.setStringList(cachedCityList,
        citiesNamesAndFavorite.map((city) => jsonEncode(city)).toList());
  }
}

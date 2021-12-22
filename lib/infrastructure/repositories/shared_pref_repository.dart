import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/domain/data_models/value_objects.dart';
import 'package:weatherapp/domain/repositories/i_local_repository.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

@LazySingleton(as: ILocalRepository)
class SharedPrefRepository implements ILocalRepository {
  final SharedPreferences sharedPreferences;
  static const cachedCityList = "CACHED_CITY_LIST";

  SharedPrefRepository(this.sharedPreferences);

  @override
  Future<Either<RepositoryFailure, List<CityName>>> loadCityList() {
    final List<String>? cityList;
    try {
      cityList = sharedPreferences.getStringList(cachedCityList);
    } on TypeError catch (_) {
      return Future.value(
          const Left(RepositoryFailure.invalidDatabaseStructure()));
    }

    if (cityList == null || cityList.isEmpty) {
      return Future.value(const Left(RepositoryFailure.notFound()));
    }

    List<CityName> cityNames =
        cityList.map((cityName) => CityName(cityName)).toList();

    if (cityNames.any((city) => !city.isValid())) {
      return Future.value(
          const Left(RepositoryFailure.invalidDatabaseStructure()));
    }

    return Future.value(right(cityNames));
  }

  @override
  Future<Either<RepositoryFailure, Unit>> saveCity(CityName cityName) async {
    Either<RepositoryFailure, List<CityName>> cityNamesOrFailure =
        await loadCityList();

    return Future.value(cityNamesOrFailure.fold((failure) async {
      if (const RepositoryFailure.notFound() == failure) {
        await saveList([
          cityName.value
              .getOrElse(() => throw const RepositoryFailure.unexpected())
        ]);
        return right(unit);
      }
      return left(failure);
    }, (r) {
      r.add(cityName);
      List<String> cityNames = r
          .map((e) => e.value
              .getOrElse(() => throw const RepositoryFailure.unexpected()))
          .toList();
      saveList(cityNames);
      return right(unit);
    }));
  }

  Future<void> saveList(List<String> cities) async {
    sharedPreferences.setStringList(cachedCityList, cities);
  }
}

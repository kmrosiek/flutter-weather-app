import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/data_models/value_objects.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/injection.dart';

class CityWeather {
  final Either<RepositoryFailure, Weather> value;
  final CityName _cityName;
  final bool favorite;

  CityWeather._create(this.value, this._cityName, this.favorite);

  static Future<CityWeather> create(
      {required String cityName, bool favor = false}) async {
    CityName cityNameObj = CityName(cityName);
    if (!cityNameObj.isValid()) {
      return CityWeather._create(
          left(const RepositoryFailure.invalidArgument()), cityNameObj, favor);
    }

    var weatherOrFailure =
        await getIt<IRemoteRepository>().getDataForCity(cityName);
    var comp = CityWeather._create(weatherOrFailure, cityNameObj, favor);
    return comp;
  }

  bool isValid() => value.isRight() && _cityName.isValid();

  String getCityNameOrThrow() => _cityName.value
      .getOrElse(() => throw const RepositoryFailure.unexpected());

  RepositoryFailure getFailureOrThrow() => value.fold((failure) => failure,
      (r) => throw ValueFailure.invalidValue(failedValue: r));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityWeather &&
        other.value == value &&
        other._cityName == _cityName;
  }

  @override
  int get hashCode =>
      17 * value.hashCode + 23 * _cityName.hashCode + favorite.hashCode;
}

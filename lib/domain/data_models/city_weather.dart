import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/injection.dart';

Future<Either<ValueFailure, Weather>> getWeatherDataForCity(String city) async {
  Either<RepositoryFailure, Weather> weatherOrFailure =
      await getIt<IRemoteRepository>().getDataForCity(city);
  return weatherOrFailure.fold(
      (l) => left(ValueFailure<String>.invalidValue(failedValue: city)),
      (r) => right(r));
}

class CityWeather {
  final Either<ValueFailure, Weather> value;
  final String cityName;

  CityWeather._create(this.value, this.cityName);

  static Future<CityWeather> create(String city) async {
    if (city.isEmpty) {
      return CityWeather._create(
          Left(ValueFailure<String>.empty(failedValue: city)), city);
    }

    var weatherOrFailure = await getWeatherDataForCity(city);
    var comp = CityWeather._create(weatherOrFailure, city);
    return comp;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityWeather &&
        other.value == value &&
        other.cityName == cityName;
  }

  @override
  int get hashCode => 17 * value.hashCode + cityName.hashCode;
}

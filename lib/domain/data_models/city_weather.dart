import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/injection.dart';

Future<Either<ValueFailure, Weather>> getWeatherDataForCity(String city) async {
  Either<ValueFailure, Weather> weatherOrFailure =
      await getIt<IRemoteRepository>().getDataForCity(city);
  return weatherOrFailure;
}

class CityWeather {
  final Either<ValueFailure, Weather> value;
  final String city;

  CityWeather._create(this.value, this.city);

  static Future<CityWeather> create(String city) async {
    if (city.isEmpty) {
      return CityWeather._create(
          Left(ValueFailure<String>.empty(failedValue: city)), city);
    }

    var a = await getWeatherDataForCity(city);
    var comp = CityWeather._create(a, city);
    return comp;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityWeather && other.value == value && other.city == city;
  }

  @override
  int get hashCode => 17 * value.hashCode + city.hashCode;
}

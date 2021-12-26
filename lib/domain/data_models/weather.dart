import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weatherapp/domain/data_models/weather_value_objects.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const Weather._();
  const factory Weather({
    required Temperature temperature,
    required Pressure pressure,
    required Humidity humidity,
    required WindSpeed windSpeed,
    required DailyTemperatures dailyTemps,
  }) = _Weather;

  bool get isValid {
    return temperature.isValid &&
        pressure.isValid &&
        humidity.isValid &&
        windSpeed.isValid &&
        dailyTemps.isValid;
  }

  String get getTemperatureOrThrow {
    return temperature.getValueOrThrow;
  }

  String get getPressureOrThrow {
    return pressure.value
        .getOrElse(() => throw const RepositoryFailure.unexpected())
        .toString();
  }

  String get getHumidityOrThrow {
    return humidity.value
        .getOrElse(() => throw const RepositoryFailure.unexpected())
        .toString();
  }

  String get getWindSpeedOrThrow {
    return windSpeed.value
        .getOrElse(() => throw const RepositoryFailure.unexpected())
        .toStringAsFixed(0);
  }
}

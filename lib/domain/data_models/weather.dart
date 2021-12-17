import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weatherapp/domain/data_models/weather_value_objects.dart';

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required Temperature temperature,
    required Pressure pressure,
    required Humidity humidity,
    required WindSpeed windSpeed,
    required DailyTemperatures dailyTemps,
  }) = _Weather;
}

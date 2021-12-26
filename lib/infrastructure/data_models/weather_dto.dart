import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/data_models/weather_value_objects.dart';

class WeatherDto {
  final double temperature;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final List<double> daysTemperature;

  WeatherDto(
      {required this.temperature,
      required this.pressure,
      required this.humidity,
      required this.windSpeed,
      required this.daysTemperature});

  factory WeatherDto.fromJson(Map<String, dynamic> json) {
    const listSize = DailyTemperatures.expectedLength;
    List<double> daily = List.filled(listSize, 0.0);
    for (int i = 0; i < listSize; i++) {
      daily[i] = (json['daily'][i]['temp']['day'] as num).toDouble();
    }

    return WeatherDto(
        temperature: (json['current']['temp'] as num).toDouble(),
        pressure: (json['current']['pressure'] as num).toInt(),
        humidity: (json['current']['humidity'] as num).toInt(),
        windSpeed: (json['current']['wind_speed'] as num).toDouble(),
        daysTemperature: daily);
  }

  Weather toDomain() {
    return Weather(
        temperature: Temperature(temperature),
        pressure: Pressure(pressure),
        humidity: Humidity(humidity),
        windSpeed: WindSpeed(windSpeed),
        dailyTemps: DailyTemperatures(
            daysTemperature.map((e) => Temperature(e)).toList()));
  }
}

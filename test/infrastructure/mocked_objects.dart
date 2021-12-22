import 'package:weatherapp/infrastructure/data_models/coordinates_dto.dart';
import 'package:weatherapp/infrastructure/data_models/weather_dto.dart';

Coordinates validCoordinates = Coordinates.fromJson({
  'coord': {'lat': 0.0, 'lon': 0.0}
});

WeatherDto validWeatherDto = WeatherDto.fromJson({
  'current': {'temp': 0.0, 'pressure': 0, 'humidity': 0, 'wind_speed': 0.0},
  'daily': [
    {
      'temp': {'day': 0.0}
    },
    {
      'temp': {'day': 0.0}
    },
    {
      'temp': {'day': 0.0}
    },
    {
      'temp': {'day': 0.0}
    },
    {
      'temp': {'day': 0.0}
    },
  ]
});

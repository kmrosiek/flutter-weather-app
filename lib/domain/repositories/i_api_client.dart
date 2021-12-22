import 'package:weatherapp/infrastructure/data_models/coordinates_dto.dart';
import 'package:weatherapp/infrastructure/data_models/weather_dto.dart';

abstract class IAPIClient {
  Future<Coordinates> getCityCoordinates(String city);
  Future<WeatherDto> getWeather(double latitude, double longitude);
}

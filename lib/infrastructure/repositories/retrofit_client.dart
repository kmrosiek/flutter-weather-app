import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/infrastructure/core/open_weather_app_id.dart';
import 'package:weatherapp/infrastructure/data_models/coordinates_dto.dart';
import 'package:weatherapp/infrastructure/data_models/weather_dto.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: 'http://api.openweathermap.org/data/2.5/')
abstract class RetrofitClient implements IAPIClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  static const appIdParam = 'appid=$appId';
  static const unitsParam = 'units=metric';
  static const excludeParams = 'exclude=minutely,hourly,alerts';

  @override
  @GET('/weather?$appIdParam')
  Future<Coordinates> getCityCoordinates(@Query('q') String city);

  @override
  @GET('/onecall?$appIdParam&$excludeParams&$unitsParam')
  Future<WeatherDto> getWeather(
      @Query('lat') double latitude, @Query('lon') double longitude);
}

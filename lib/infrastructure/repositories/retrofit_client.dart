import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/infrastructure/core/open_weather_app_id.dart';
import 'package:weatherapp/infrastructure/data_models/coordinates_dto.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: 'http://api.openweathermap.org/data/2.5/')
abstract class RetrofitClient implements IAPIClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @override
  @GET('/weather?appid=$appId')
  Future<Coordinates> getCityCoordinates(@Query('q') String city);
}

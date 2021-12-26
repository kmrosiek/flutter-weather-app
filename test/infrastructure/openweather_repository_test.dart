import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherapp/domain/core/network_info.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/infrastructure/repositories/openweather_repository.dart';
import 'dio_error_generator.dart';
import 'mocked_objects.dart';
import 'openweather_repository_test.mocks.dart';

@GenerateMocks([INetworkInfo])
@GenerateMocks([IAPIClient])
void main() {
  late MockINetworkInfo mockINetworkInfo;
  late MockIAPIClient mockIAPIClient;
  late OpenWeatherRepository openWeather;
  const validCity = "Warsaw";
  const nonExistentCity = "thiscitydoesnotexist";

  setUpAll(() {
    mockINetworkInfo = MockINetworkInfo();
    mockIAPIClient = MockIAPIClient();
    GetIt.instance.registerSingleton<IAPIClient>(mockIAPIClient);
    openWeather = OpenWeatherRepository(
        networkInfo: mockINetworkInfo, apiClient: mockIAPIClient);
  });

  setUp(() {
    when(mockINetworkInfo.isConnected).thenAnswer((_) async => true);
  });

  group('getDataForCity', () {
    test(
      'should return RepositoryFailure.noInternet when there is no connection '
      'to the Internet',
      () async {
        // arrange
        when(mockINetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        final result = await openWeather.getDataForCity(validCity);
        // assert
        expect(result, left(const RepositoryFailure.noInternet()));
      },
    );

    test(
      'should return RepositoryFailure.notFound when pass a city that '
      'do not exist',
      () async {
        // arrange
        when(mockIAPIClient.getCityCoordinates(any)).thenAnswer(
            (_) async => Future.error(DioErrorGenerator.notFound()));
        // act
        final result = await openWeather.getDataForCity(nonExistentCity);
        // assert
        expect(result, left(const RepositoryFailure.notFound()));
      },
    );

    test(
      'should return RepositoryFailure.inssuficientPermission when server '
      'responses with unauthorized statusCode',
      () async {
        // arrange
        when(mockIAPIClient.getCityCoordinates(any)).thenAnswer(
            (_) async => Future.error(DioErrorGenerator.unauthorized()));
        final result = await openWeather.getDataForCity(validCity);
        // assert
        expect(result, left(const RepositoryFailure.insufficientPermission()));
      },
    );

    test(
      'should return RepositoryFailure.invalidDatabaseStructure when during '
      'json conversion TypeError is raised',
      () async {
        // arrange
        when(mockIAPIClient.getCityCoordinates(any))
            .thenAnswer((_) async => Future.error(TypeError()));
        final result = await openWeather.getDataForCity(validCity);
        // assert
        expect(
            result, left(const RepositoryFailure.invalidDatabaseStructure()));
      },
    );

    test(
      'should return RepositoryFailure.invalidDatabaseStructure when during '
      'json conversion RangeError is raised',
      () async {
        // arrange
        when(mockIAPIClient.getCityCoordinates(any))
            .thenAnswer((_) async => Future.error(RangeError('Out of range')));
        final result = await openWeather.getDataForCity(validCity);
        // assert
        expect(
            result, left(const RepositoryFailure.invalidDatabaseStructure()));
      },
    );

    test(
      'should return Weather object with unknown state(can be valid or invalid)'
      ' when getCityCoordinates returns valid coords and getWeather returns '
      'correct data',
      () async {
        // arrange
        when(mockIAPIClient.getCityCoordinates(any))
            .thenAnswer((_) async => Future.value(validCoordinates));
        when(mockIAPIClient.getWeather(any, any))
            .thenAnswer((_) async => Future.value(validWeatherDto));
        final result = await openWeather.getDataForCity(validCity);
        // assert
        expect(result, right(validWeatherDto.toDomain()));
      },
    );
  });
}

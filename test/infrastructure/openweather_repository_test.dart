import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherapp/domain/core/network_info.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/infrastructure/repositories/openweather_repository.dart';
import 'dio_error_generator_test.dart';
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
    openWeather = OpenWeatherRepository(
        networkInfo: mockINetworkInfo, apiClient: mockIAPIClient);
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
        when(mockINetworkInfo.isConnected).thenAnswer((_) async => true);
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
        when(mockINetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockIAPIClient.getCityCoordinates(any)).thenAnswer(
            (_) async => Future.error(DioErrorGenerator.unauthorized()));
        final result = await openWeather.getDataForCity(nonExistentCity);
        // assert
        expect(result, left(const RepositoryFailure.insufficientPermission()));
      },
    );
  });
}

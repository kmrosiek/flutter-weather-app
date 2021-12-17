import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherapp/domain/core/network_info.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/infrastructure/repositories/openweather_repository.dart';
import 'openweather_repository_test.mocks.dart';

@GenerateMocks([INetworkInfo])
void main() {
  late MockINetworkInfo mockINetworkInfo;
  late OpenWeatherRepository openWeather;
  const validCity = "Warsaw";

  setUpAll(() {
    mockINetworkInfo = MockINetworkInfo();
    openWeather = OpenWeatherRepository(networkInfo: mockINetworkInfo);
  });
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
}

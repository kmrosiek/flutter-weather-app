import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'city_weather_test.mocks.dart';

@GenerateMocks([IRemoteRepository])
void main() {
  late MockIRemoteRepository mockRemote;
  setUpAll(() {
    mockRemote = MockIRemoteRepository();
    GetIt.instance.registerSingleton<IRemoteRepository>(mockRemote);
  });
  const String validCityName = "New York";
  test(
    'should return invalid object when empty string is passed',
    () async {
      // arrange
      const String emptyCityName = "";
      // act
      CityWeather cityWeather = await CityWeather.create(emptyCityName);
      // assert
      expect(cityWeather.value,
          const Left(ValueFailure<String>.empty(failedValue: emptyCityName)));
    },
  );

  test(
    'should call IRemoteRepository.getDataForCity when passed not empty city name',
    () async {
      // arrange
      when(mockRemote.getDataForCity(any))
          .thenAnswer((_) async => const Right(Weather(validCityName)));
      // act
      await CityWeather.create(validCityName);
      // assert
      verify(mockRemote.getDataForCity(any));
    },
  );

  test(
    'should return invalid object in case of any error in getDataForCity '
    'method when passed not empty string',
    () async {
      // arrange
      when(mockRemote.getDataForCity(any)).thenAnswer((_) async => const Left(
          ValueFailure<String>.invalidValue(failedValue: validCityName)));
      // act
      CityWeather cityWeather = await CityWeather.create(validCityName);
      // assert
      expect(
          cityWeather.value,
          const Left(
              ValueFailure<String>.invalidValue(failedValue: validCityName)));
    },
  );
  test(
    'should return valid object in case of no error in getDataForCity '
    'method when passed not empty string',
    () async {
      // arrange
      Either<ValueFailure, Weather> expectedReturn;
      expectedReturn = const Right(Weather(validCityName));
      when(mockRemote.getDataForCity(any))
          .thenAnswer((_) async => expectedReturn);
      // act
      CityWeather cityWeather = await CityWeather.create(validCityName);
      // assert
      expect(cityWeather.value, const Right(Weather(validCityName)));
    },
  );

  test(
    'should set cityName member in case of no error in getDataForCity '
    'method when passed not empty string',
    () async {
      // arrange
      Either<ValueFailure, Weather> expectedReturn;
      expectedReturn = const Right(Weather(validCityName));
      when(mockRemote.getDataForCity(any))
          .thenAnswer((_) async => expectedReturn);
      // act
      CityWeather cityWeather = await CityWeather.create(validCityName);
      // assert
      expect(cityWeather.cityName, validCityName);
    },
  );
}

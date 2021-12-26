import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/domain/data_models/city_name_and_favorite.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/infrastructure/repositories/shared_pref_repository.dart';

import '../domain/data_models/city_weather_test.mocks.dart';
import 'mocked_objects.dart';
import 'shared_pref_repository_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late SharedPrefRepository sharedPref;
  late SharedPreferences mockSharedPreferences;
  late MockIRemoteRepository mockIRemoteRepository;

  setUpAll(() {
    mockSharedPreferences = MockSharedPreferences();
    sharedPref = SharedPrefRepository(mockSharedPreferences);
    mockIRemoteRepository = MockIRemoteRepository();
    GetIt.instance.registerSingleton<IRemoteRepository>(mockIRemoteRepository);
    when(mockIRemoteRepository.getDataForCity(any)).thenAnswer(
        (realInvocation) => Future.value(right(validWeatherDto.toDomain())));
  });

  group('loadCityList method', () {
    test(
      'should return RepositoryFailure.notFound when key cannot be found.',
      () async {
        // arrange
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn(null);
        // act
        final result = await sharedPref.loadCityList();
        // assert
        expect(result, left(const RepositoryFailure.notFound()));
      },
    );

    test(
      'should return RepositoryFailure.notFound when returned list is empty',
      () async {
        // arrange
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn(<String>[]);
        // act
        final result = await sharedPref.loadCityList();
        // assert
        expect(result, left(const RepositoryFailure.notFound()));
      },
    );

    test(
      'should return RepositoryFailure.invalidDatabaseStructure when returned '
      'type is not a list of strings',
      () async {
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenThrow(TypeError());
        // act
        final result = await sharedPref.loadCityList();
        // assert
        expect(
            result, left(const RepositoryFailure.invalidDatabaseStructure()));
      },
    );

    test(
      'should return RepositoryFailure.invalidDatabaseStructure when returned '
      'list contains at least one string which results in invalid CityName state',
      () async {
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn(<String>["Warsaw", ""]);
        // act
        final result = await sharedPref.loadCityList();
        // assert
        expect(
            result, left(const RepositoryFailure.invalidDatabaseStructure()));
      },
    );

    test(
      'should return List of CityNameAndFavorite when SharedPref contains list of valid cities ',
      () async {
        var city1 =
            const CityNameAndFavorite(cityName: 'Warsaw', favorite: false);
        var city2 =
            const CityNameAndFavorite(cityName: 'Berlin', favorite: true);

        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([jsonEncode(city1), jsonEncode(city2)]);
        // act
        final result = await sharedPref.loadCityList();
        // assert
        expect(result.getOrElse(() => throw Exception()), [city1, city2]);
      },
    );
  });

  group('saveCity method', () {
    const validCity = CityNameAndFavorite(cityName: 'warsaw', favorite: false);

    test(
      'should call setStringList with lowercase even when passed cityname with '
      'capital letters.',
      () async {
        // arrange
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([]);
        when(mockSharedPreferences.setStringList(
                SharedPrefRepository.cachedCityList, [jsonEncode(validCity)]))
            .thenAnswer((_) async => true);
        // act
        final result = await sharedPref.saveCity(validCity);
        // assert
        expect(result, right(unit));
      },
    );

    test(
      'should return Unit when passed valid CityName and city list is empty yet',
      () async {
        // arrange
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([]);
        when(mockSharedPreferences.setStringList(
                SharedPrefRepository.cachedCityList, [jsonEncode(validCity)]))
            .thenAnswer((_) async => true);
        // act
        final result = await sharedPref.saveCity(validCity);
        // assert
        expect(result, right(unit));
      },
    );

    test(
      'should return Unit while saving city only once when the city was already '
      'present in sharedPreferences.',
      () async {
        // arrange
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([jsonEncode(validCity)]);
        when(mockSharedPreferences.setStringList(
                SharedPrefRepository.cachedCityList, [jsonEncode(validCity)]))
            .thenAnswer((_) async => true);
        // act
        final result = await sharedPref.saveCity(validCity);
        // assert
        expect(result, right(unit));
      },
    );

    test(
      'should return Unit and update boolean when there is the city '
      'saved on the list already.',
      () async {
        const newValueCity =
            CityNameAndFavorite(cityName: 'warsaw', favorite: true);
        // arrange
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([jsonEncode(validCity)]);
        when(mockSharedPreferences.setStringList(
            SharedPrefRepository.cachedCityList,
            [jsonEncode(newValueCity)])).thenAnswer((_) async => true);
        // act
        final result = await sharedPref.saveCity(newValueCity);
        // assert
        expect(result, right(unit));
      },
    );
  });

  group('deleteCity', () {
    const validCity = CityNameAndFavorite(cityName: 'warsaw', favorite: false);
    test(
      'should return RepositoryFailure.notFound when city cannot be found',
      () async {
        // arrange
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn(null);
        // act
        final result = await sharedPref.deleteCity(validCity);
        // assert
        expect(result, left(const RepositoryFailure.notFound()));
      },
    );

    test(
      'should return List of CityNameAndFavorite when SharedPref contains list of valid cities ',
      () async {
        var city1 =
            const CityNameAndFavorite(cityName: 'Warsaw', favorite: false);
        var city2 =
            const CityNameAndFavorite(cityName: 'Berlin', favorite: true);

        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([jsonEncode(city1), jsonEncode(city2)]);
        when(mockSharedPreferences.setStringList(
                SharedPrefRepository.cachedCityList, [jsonEncode(city1)]))
            .thenAnswer((_) => Future.value(true));
        // act
        await sharedPref.deleteCity(city2);
        // assert
        verify(mockSharedPreferences.setStringList(
            SharedPrefRepository.cachedCityList, [jsonEncode(city1)]));
      },
    );
  });
}

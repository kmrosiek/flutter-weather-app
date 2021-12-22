import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/domain/data_models/value_objects.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/infrastructure/repositories/shared_pref_repository.dart';

import 'shared_pref_repository_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late SharedPrefRepository sharedPref;
  late SharedPreferences mockSharedPreferences;
  setUpAll(() {
    mockSharedPreferences = MockSharedPreferences();
    sharedPref = SharedPrefRepository(mockSharedPreferences);
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
      'should return List of CityNames when SharedPref contains list of valid cities ',
      () async {
        List<String> cities = ["Warsaw", "London"];
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn(cities);
        // act
        final result = await sharedPref.loadCityList();
        // assert
        expect(result.getOrElse(() => throw Exception()),
            List.generate(cities.length, (index) => CityName(cities[index])));
      },
    );
  });

  group('saveCity method', () {
    test(
      'should return Unit when passed valid CityName and city list is empty yet',
      () async {
        // arrange
        const String city = 'Warsaw';
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([]);
        when(mockSharedPreferences.setStringList(
                SharedPrefRepository.cachedCityList, List.filled(1, city)))
            .thenAnswer((_) async => true);
        // act
        final result = await sharedPref.saveCity(CityName(city));
        // assert
        expect(result, right(unit));
      },
    );

    test(
      'should return Unit when passed valid CityName and there are cities '
      'saved on the list already.',
      () async {
        // arrange
        const String city = 'Warsaw';
        when(mockSharedPreferences
                .getStringList(SharedPrefRepository.cachedCityList))
            .thenReturn([city]);
        when(mockSharedPreferences.setStringList(
                SharedPrefRepository.cachedCityList, [city, city]))
            .thenAnswer((_) async => true);
        // act
        final result = await sharedPref.saveCity(CityName(city));
        // assert
        expect(result, right(unit));
      },
    );
  });
}

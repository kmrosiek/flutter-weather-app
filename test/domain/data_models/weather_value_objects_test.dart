import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/data_models/weather_value_objects.dart';

void main() {
  test(
    'should return invalid DailyTemperature when passed list with '
    'length different than DailyTemperatures.expectedLength',
    () async {
      // arrange
      const expectedLength = DailyTemperatures.expectedLength;
      final List<Temperature> temperatures =
          List.filled(expectedLength + 1, Temperature(0.0));
      // act
      final result = DailyTemperatures(temperatures);
      // assert
      expect(
          result.value,
          left(const ValueFailure.outOfRange(
              failedValue: expectedLength + 1,
              min: expectedLength,
              max: expectedLength)));
    },
  );
  test(
    'should return invalid DailyTemperature when passed list '
    'with at least one temperature failure.',
    () async {
      // arrange
      final maxTemperature = Temperature.max;
      final List<Temperature> temperatures =
          List.filled(DailyTemperatures.expectedLength, Temperature(0.0));
      temperatures[DailyTemperatures.expectedLength - 1] =
          Temperature(maxTemperature + 1);
      // act
      final result = DailyTemperatures(temperatures);
      // assert
      expect(
          result.value,
          left(const ValueFailure.invalidValue(
              failedValue: DailyTemperatures.expectedLength - 1)));
    },
  );

  test(
    'should return valid DailyTemperature when passed list with valid elements '
    'and within list length limit.',
    () async {
      // arrange
      final List<Temperature> temperatures =
          List.filled(DailyTemperatures.expectedLength, Temperature(0.0));
      // act
      final result = DailyTemperatures(temperatures);
      // assert
      expect(result.value, right(temperatures));
    },
  );
}

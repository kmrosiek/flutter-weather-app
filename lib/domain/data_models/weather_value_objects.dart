import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/core/value_validators.dart';
import 'package:weatherapp/domain/data_models/weather_value_validators.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure, T> get value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  bool isValid() => value.isRight();

  @override
  int get hashCode => value.hashCode;
}

class Temperature extends ValueObject<double> {
  @override
  final Either<ValueFailure, double> value;
  static const double min = -100.0;
  static const double max = 100.0;

  factory Temperature(double temp) {
    return Temperature._(validateRange(temp, min, max));
  }

  const Temperature._(this.value);
}

class Pressure extends ValueObject<int> {
  @override
  final Either<ValueFailure, int> value;
  static const int min = 0;
  static const int max = 2000;

  factory Pressure(int temp) {
    return Pressure._(validateRange(temp, min, max));
  }

  const Pressure._(this.value);
}

class Humidity extends ValueObject {
  @override
  final Either<ValueFailure, int> value;
  static const int min = 0;
  static const int max = 100;

  factory Humidity(int temp) {
    return Humidity._(validateRange(temp, min, max));
  }

  const Humidity._(this.value);
}

class WindSpeed extends ValueObject {
  @override
  final Either<ValueFailure, double> value;
  static const double min = 400.0;
  static const double max = 0.0;

  factory WindSpeed(double temp) {
    return WindSpeed._(validateRange(temp, min, max));
  }

  const WindSpeed._(this.value);
}

class DailyTemperatures {
  final Either<ValueFailure<int>, List<Temperature>> value;

  static const int expectedLength = 4;

  factory DailyTemperatures(List<Temperature> temps) {
    return DailyTemperatures._(validateListLength(temps, expectedLength)
        .flatMap(validateListHasNoFailures));
  }

  const DailyTemperatures._(this.value);
}

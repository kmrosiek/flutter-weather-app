import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/core/value_validators.dart';
import 'package:weatherapp/domain/data_models/value_objects.dart';
import 'package:weatherapp/domain/data_models/weather_value_validators.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

class Temperature extends ValueObject<double> {
  @override
  final Either<ValueFailure, double> value;
  static const double min = -100.0;
  static const double max = 100.0;

  factory Temperature(double temp) {
    return Temperature._(validateRange(temp, min, max));
  }

  String get getValueOrThrow {
    return value
        .getOrElse(() => throw const RepositoryFailure.unexpected())
        .toStringAsFixed(0);
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
  static const double min = 0.0;
  static const double max = 400.0;

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

  bool get isValid {
    return value.fold((failure) => false,
        (temps) => temps.indexWhere((temp) => !temp.isValid) == -1);
  }

  const DailyTemperatures._(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! DailyTemperatures) return false;

    if (value.isLeft() && other.value.isLeft()) return other.value == value;

    if (value.isRight() && other.value.isRight()) {
      return const ListEquality().equals(value.getOrElse(() => throw Error()),
          other.value.getOrElse(() => throw Error()));
    }

    return false;
  }

  @override
  int get hashCode => value.hashCode;
}

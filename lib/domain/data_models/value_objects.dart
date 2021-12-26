import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/data_models/value_validators.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure, T> get value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  bool get isValid => value.isRight();

  @override
  int get hashCode => value.hashCode;
}

class CityName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CityName(String cityName) {
    return CityName._(validateStringIsNotEmpty(cityName));
  }

  const CityName._(this.value);
}

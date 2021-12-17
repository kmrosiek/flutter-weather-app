import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/core/failures.dart';

Either<ValueFailure<T>, T> validateRange<T extends num>(T value, T min, T max) {
  if (value >= min && value <= max) {
    return right(value);
  } else {
    return left(
        ValueFailure.outOfRange(failedValue: value, min: min, max: max));
  }
}

Either<ValueFailure<int>, List<T>> validateListLength<T>(
    List<T> temps, int expectedLength) {
  if (temps.length != expectedLength) {
    return Left(ValueFailure.outOfRange(
        failedValue: temps.length, min: expectedLength, max: expectedLength));
  } else {
    return right(temps);
  }
}

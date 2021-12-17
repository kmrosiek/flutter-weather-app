import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.empty({
    required T failedValue,
  }) = Empty<T>;
  const factory ValueFailure.invalidValue({
    required T failedValue,
  }) = InvalidValue<T>;
  const factory ValueFailure.outOfRange({
    required T failedValue,
    required T min,
    required T max,
  }) = OutOfRange<T>;
}

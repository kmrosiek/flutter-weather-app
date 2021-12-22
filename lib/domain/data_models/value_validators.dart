import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/core/failures.dart';

Either<ValueFailure<String>, String> validateStringIsNotEmpty(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  } else {
    return right(input);
  }
}

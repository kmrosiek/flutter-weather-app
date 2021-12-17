import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/core/value_validators.dart';

void main() {
  group('validateRange method', () {
    test(
      'should fail when passed argument below min',
      () async {
        // arrange
        const actual = 0;
        const min = 1;
        const max = 2;
        // act, assert
        expect(
            validateRange(actual, min, max),
            left(const ValueFailure.outOfRange(
                failedValue: actual, min: min, max: max)));
      },
    );

    test(
      'should fail when passed argument above max',
      () async {
        // arrange
        const actual = 3;
        const min = 1;
        const max = 2;
        // act, assert
        expect(
            validateRange(actual, min, max),
            left(const ValueFailure.outOfRange(
                failedValue: actual, min: min, max: max)));
      },
    );
    test(
      'should pass when passed argument does not exceed limits',
      () async {
        // arrange
        const actual = 1;
        const min = 1;
        const max = 1;
        // act, assert
        expect(validateRange(actual, min, max), right(actual));
      },
    );
  });

  group('validateListLength', () {
    test(
      'should return ValueFailure<int> with max limit when passing list '
      'with length larger than limit',
      () async {
        // arrange
        const maxLength = 2;
        List<int> list = List.filled(maxLength + 1, 0);
        // act
        final result = validateListLength(list, maxLength);
        // assert
        expect(
            result,
            left(ValueFailure.outOfRange(
                failedValue: list.length, min: maxLength, max: maxLength)));
      },
    );

    test(
      'should return ValueFailure<int> with max limit when passing empty list',
      () async {
        // arrange
        const maxLength = 2;
        List<int> list = List.empty();
        // act
        final result = validateListLength(list, maxLength);
        // assert
        expect(
            result,
            left(ValueFailure.outOfRange(
                failedValue: list.length, min: maxLength, max: maxLength)));
      },
    );

    test(
      'should return list when passing list within max length limit.',
      () async {
        // arrange
        const maxLength = 2;
        List<int> list = List.filled(2, 0);
        // act
        final result = validateListLength(list, maxLength);
        // assert
        expect(result, right(list));
      },
    );
  });
}

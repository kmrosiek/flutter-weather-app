import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/data_models/weather_value_objects.dart';

Either<ValueFailure<int>, List<Temperature>> validateListHasNoFailures(
    List<Temperature> temps) {
  var failedTemperatureIndex =
      temps.indexWhere((temperature) => !temperature.isValid());
  if (failedTemperatureIndex == -1) {
    return right(temps);
  } else {
    return left(ValueFailure.invalidValue(failedValue: failedTemperatureIndex));
  }
}

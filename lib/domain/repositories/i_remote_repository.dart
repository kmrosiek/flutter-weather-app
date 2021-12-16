import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/core/failures.dart';
import 'package:weatherapp/domain/data_models/weather.dart';

abstract class IRemoteRepository {
  Future<Either<ValueFailure, Weather>> getDataForCity(String city);
}

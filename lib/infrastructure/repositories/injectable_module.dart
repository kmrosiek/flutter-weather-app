import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/infrastructure/repositories/retrofit_client.dart';

@module
abstract class InjectableModule {
  @LazySingleton(as: IAPIClient)
  RetrofitClient get retrofitClient => RetrofitClient(Dio());
}

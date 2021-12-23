import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/domain/repositories/i_api_client.dart';
import 'package:weatherapp/infrastructure/repositories/retrofit_client.dart';

@module
abstract class InjectableModule {
  @lazySingleton
  Dio get dio => Dio();

  @LazySingleton(as: IAPIClient)
  RetrofitClient get retrofitClient => RetrofitClient(Dio());

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i9;
import 'package:shared_preferences/shared_preferences.dart' as _i10;

import 'application/add_edit_city/add_edit_city_bloc.dart' as _i13;
import 'application/cities_overview/cities_overview_bloc.dart' as _i14;
import 'application/network_info/internet_checker_network_info.dart' as _i6;
import 'domain/core/network_info.dart' as _i5;
import 'domain/repositories/i_api_client.dart' as _i4;
import 'domain/repositories/i_local_repository.dart' as _i11;
import 'domain/repositories/i_remote_repository.dart' as _i7;
import 'infrastructure/repositories/injectable_module.dart' as _i15;
import 'infrastructure/repositories/openweather_repository.dart' as _i8;
import 'infrastructure/repositories/shared_pref_repository.dart'
    as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectableModule = _$InjectableModule();
  gh.lazySingleton<_i3.Dio>(() => injectableModule.dio);
  gh.lazySingleton<_i4.IAPIClient>(() => injectableModule.retrofitClient);
  gh.lazySingleton<_i5.INetworkInfo>(() => _i6.InternetCheckerNetworkInfo());
  gh.lazySingleton<_i7.IRemoteRepository>(() => _i8.OpenWeatherRepository(
      networkInfo: get<_i5.INetworkInfo>(), apiClient: get<_i4.IAPIClient>()));
  gh.lazySingleton<_i9.InternetConnectionChecker>(
      () => injectableModule.internetConnectionChecker);
  await gh.factoryAsync<_i10.SharedPreferences>(
      () => injectableModule.sharedPreferences,
      preResolve: true);
  gh.lazySingleton<_i11.ILocalRepository>(
      () => _i12.SharedPrefRepository(get<_i10.SharedPreferences>()));
  gh.factory<_i13.AddEditCityBloc>(
      () => _i13.AddEditCityBloc(get<_i11.ILocalRepository>()));
  gh.factory<_i14.CitiesOverviewBloc>(() => _i14.CitiesOverviewBloc(
      weatherClient: get<_i7.IRemoteRepository>(),
      localRepository: get<_i11.ILocalRepository>()));
  return get;
}

class _$InjectableModule extends _i15.InjectableModule {}

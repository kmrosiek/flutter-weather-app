// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

import 'application/add_edit_city/add_edit_city_bloc.dart' as _i3;
import 'application/network_info/internet_checker_network_info.dart' as _i9;
import 'domain/core/network_info.dart' as _i8;
import 'domain/repositories/i_api_client.dart' as _i4;
import 'domain/repositories/i_local_repository.dart' as _i5;
import 'domain/repositories/i_remote_repository.dart' as _i10;
import 'infrastructure/repositories/injectable_module.dart' as _i12;
import 'infrastructure/repositories/openweather_repository.dart' as _i11;
import 'infrastructure/repositories/shared_pref_repository.dart'
    as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectableModule = _$InjectableModule();
  gh.factory<_i3.AddEditCityBloc>(() => _i3.AddEditCityBloc());
  gh.lazySingleton<_i4.IAPIClient>(() => injectableModule.retrofitClient);
  gh.lazySingleton<_i5.ILocalRepository>(
      () => _i6.SharedPrefRepository(get<_i7.SharedPreferences>()));
  gh.lazySingleton<_i8.INetworkInfo>(() => _i9.InternetCheckerNetworkInfo());
  gh.lazySingleton<_i10.IRemoteRepository>(() => _i11.OpenWeatherRepository(
      networkInfo: get<_i8.INetworkInfo>(), apiClient: get<_i4.IAPIClient>()));
  return get;
}

class _$InjectableModule extends _i12.InjectableModule {}

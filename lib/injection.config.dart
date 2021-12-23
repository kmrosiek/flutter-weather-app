// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import 'application/add_edit_city/add_edit_city_bloc.dart' as _i11;
import 'application/network_info/internet_checker_network_info.dart' as _i8;
import 'domain/core/network_info.dart' as _i7;
import 'domain/repositories/i_api_client.dart' as _i3;
import 'domain/repositories/i_local_repository.dart' as _i4;
import 'domain/repositories/i_remote_repository.dart' as _i9;
import 'infrastructure/repositories/injectable_module.dart' as _i12;
import 'infrastructure/repositories/openweather_repository.dart' as _i10;
import 'infrastructure/repositories/shared_pref_repository.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectableModule = _$InjectableModule();
  gh.lazySingleton<_i3.IAPIClient>(() => injectableModule.retrofitClient);
  gh.lazySingleton<_i4.ILocalRepository>(
      () => _i5.SharedPrefRepository(get<_i6.SharedPreferences>()));
  gh.lazySingleton<_i7.INetworkInfo>(() => _i8.InternetCheckerNetworkInfo());
  gh.lazySingleton<_i9.IRemoteRepository>(() => _i10.OpenWeatherRepository(
      networkInfo: get<_i7.INetworkInfo>(), apiClient: get<_i3.IAPIClient>()));
  gh.factory<_i11.AddEditCityBloc>(
      () => _i11.AddEditCityBloc(localRepository: get<_i4.ILocalRepository>()));
  return get;
}

class _$InjectableModule extends _i12.InjectableModule {}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/add_edit_city/add_edit_city_bloc.dart' as _i3;
import 'application/network_info/internet_checker_network_info.dart' as _i5;
import 'domain/core/network_info.dart' as _i4;
import 'domain/repositories/i_remote_repository.dart' as _i6;
import 'infrastructure/repositories/openweather_repository.dart'
    as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.AddEditCityBloc>(() => _i3.AddEditCityBloc());
  gh.lazySingleton<_i4.INetworkInfo>(() => _i5.InternetCheckerNetworkInfo());
  gh.lazySingleton<_i6.IRemoteRepository>(
      () => _i7.OpenWeatherRepository(networkInfo: get<_i4.INetworkInfo>()));
  return get;
}

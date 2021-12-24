import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weatherapp/domain/data_models/city_name_and_favorite.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/domain/data_models/value_objects.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/repositories/i_local_repository.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/injection.dart';

part 'add_edit_city_event.dart';
part 'add_edit_city_state.dart';
part 'add_edit_city_bloc.freezed.dart';

@injectable
class AddEditCityBloc extends Bloc<AddEditCityEvent, AddEditCityState> {
  final ILocalRepository localRepository;

  AddEditCityBloc(this.localRepository)
      : super(const AddEditCityState.initial()) {
    on<_CityNameSubmitted>(tryToCreateAndSaveCityWeather);
  }

  void tryToCreateAndSaveCityWeather(
      AddEditCityEvent event, Emitter<AddEditCityState> emit) async {
    emit(const AddEditCityState.loading());

    CityWeather cityWeather =
        await CityWeather.create(cityName: event.cityName);

    if (!cityWeather.isValid()) {
      emit(AddEditCityState.weatherRetrieveError(
          cityWeather.getFailureOrThrow()));
      return;
    }

    var failureOrSuccess = await localRepository.saveCity(CityNameAndFavorite(
        cityName: cityWeather.getCityNameOrThrow(),
        favorite: cityWeather.favorite));

    emit(failureOrSuccess.fold(
        (failure) => AddEditCityState.weatherRetrieveError(failure),
        (success) => const AddEditCityState.weatherRetrieveSuccess()));
  }
}

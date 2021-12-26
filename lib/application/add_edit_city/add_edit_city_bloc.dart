import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weatherapp/domain/data_models/city_name_and_favorite.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/domain/repositories/i_local_repository.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

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

    CityWeather cityWeather = await CityWeather.create(
        cityName: event.cityName, favor: event.favorite);

    if (!cityWeather.isValid()) {
      emit(AddEditCityState.submissionFailure(cityWeather.getFailureOrThrow()));
      return;
    }

    var failureOrSuccess = await localRepository.saveCity(CityNameAndFavorite(
        cityName: cityWeather.getCityNameOrThrow(),
        favorite: cityWeather.favorite));

    emit(failureOrSuccess.fold(
        (failure) => AddEditCityState.submissionFailure(failure),
        (success) => AddEditCityState.submissionSuccess(cityWeather)));
  }
}

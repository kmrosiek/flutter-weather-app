import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';

part 'add_edit_city_event.dart';
part 'add_edit_city_state.dart';
part 'add_edit_city_bloc.freezed.dart';

@injectable
class AddEditCityBloc extends Bloc<AddEditCityEvent, AddEditCityState> {
  AddEditCityBloc() : super(const AddEditCityState.initial()) {
    on<_CityNameSubmitted>(tryToCreateCityWeather);
  }

  void tryToCreateCityWeather(
      AddEditCityEvent event, Emitter<AddEditCityState> emit) async {
    emit(const AddEditCityState.loading());
    CityWeather cityWeather = await CityWeather.create(event.cityName);
    emit(cityWeather.value.fold(
        (l) => const AddEditCityState.weatherRetrieveError(),
        (r) => const AddEditCityState.weatherRetrieveSuccess()));
  }
}

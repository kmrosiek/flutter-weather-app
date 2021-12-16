part of 'add_edit_city_bloc.dart';

@freezed
class AddEditCityEvent with _$AddEditCityEvent {
  const factory AddEditCityEvent.cityNameSubmitted(String cityName) =
      _CityNameSubmitted;
}

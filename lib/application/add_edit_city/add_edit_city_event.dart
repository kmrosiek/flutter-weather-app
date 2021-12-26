part of 'add_edit_city_bloc.dart';

@freezed
class AddEditCityEvent with _$AddEditCityEvent {
  const factory AddEditCityEvent.citySubmitted(String cityName, bool favorite) =
      _CityNameSubmitted;
}

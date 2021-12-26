part of 'cities_overview_bloc.dart';

@freezed
class CitiesOverviewEvent with _$CitiesOverviewEvent {
  const factory CitiesOverviewEvent.fetchData() = _FetchData;
  const factory CitiesOverviewEvent.favoriteSwitched(CityWeather cityWeather) =
      _FavoriteSwitched;
  const factory CitiesOverviewEvent.deleted(CityWeather cityWeather) = _Deleted;
  const factory CitiesOverviewEvent.added(CityWeather cityWeather) = _Added;
  const factory CitiesOverviewEvent.edited(
      CityWeather oldCity, CityWeather newCity) = _Edited;
  const factory CitiesOverviewEvent.switchSort() = _SwitchSort;
}

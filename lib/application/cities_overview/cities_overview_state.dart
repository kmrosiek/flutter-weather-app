part of 'cities_overview_bloc.dart';

@freezed
class CitiesOverviewState with _$CitiesOverviewState {
  const factory CitiesOverviewState.initial() = _Initial;
  const factory CitiesOverviewState.loading() = _Loading;
  const factory CitiesOverviewState.weatherRetrieveError(
      RepositoryFailure repositoryFailure) = _WeatherRetrieveError;
  const factory CitiesOverviewState.weatherRetrieveSuccess(
      List<CityWeather> citiesWeather) = _WeatherRetrieveSuccess;
  const factory CitiesOverviewState.favoriteSwitchFailure(
      RepositoryFailure repositoryFailure) = _FavoriteSwitchFailure;
}

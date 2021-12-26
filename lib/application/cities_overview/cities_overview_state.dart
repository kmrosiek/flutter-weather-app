part of 'cities_overview_bloc.dart';

@freezed
class CitiesOverviewState with _$CitiesOverviewState {
  const factory CitiesOverviewState({
    required List<CityWeather> citiesWeather,
    required bool isLoading,
    required Option<RepositoryFailure> repositoryFailure,
  }) = _CitiesOverviewState;

  factory CitiesOverviewState.initial() => CitiesOverviewState(
        citiesWeather: [],
        isLoading: true,
        repositoryFailure: none(),
      );
}

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:weatherapp/domain/data_models/city_name_and_favorite.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/domain/repositories/i_local_repository.dart';
import 'package:weatherapp/domain/repositories/i_remote_repository.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';

part 'cities_overview_event.dart';
part 'cities_overview_state.dart';
part 'cities_overview_bloc.freezed.dart';

@injectable
class CitiesOverviewBloc
    extends Bloc<CitiesOverviewEvent, CitiesOverviewState> {
  final IRemoteRepository weatherClient;
  final ILocalRepository localRepository;
  List<CityWeather> citiesWeather = [];

  CitiesOverviewBloc(
      {required this.weatherClient, required this.localRepository})
      : super(const _Initial()) {
    on<_FetchData>((event, emit) async {
      Either<RepositoryFailure, List<CityNameAndFavorite>> citiesOrFailure =
          await localRepository.loadCityList();

      await citiesOrFailure.fold(
          (failure) async =>
              emit(CitiesOverviewState.weatherRetrieveError(failure)),
          (cities) async {
        var citiesFutures = cities
            .map((city) => CityWeather.create(
                cityName: city.cityName, favor: city.favorite))
            .toList();

        var futures = Future.wait(citiesFutures);
        citiesWeather = (await futures).toList();
        var indexOfInvalid =
            citiesWeather.indexWhere((cityWeather) => !cityWeather.isValid());
        emit(indexOfInvalid == -1
            ? CitiesOverviewState.weatherRetrieveSuccess(citiesWeather)
            : CitiesOverviewState.weatherRetrieveError(
                citiesWeather[indexOfInvalid].getFailureOrThrow()));
      });
    });

    on<_FavoriteSwitched>((event, emit) async {
      (await localRepository.saveCity(CityNameAndFavorite(
              cityName: event.cityWeather.getCityNameOrThrow(),
              favorite: event.cityWeather.favorite)))
          .fold(
              (failure) =>
                  emit(CitiesOverviewState.favoriteSwitchFailure(failure)),
              (r) => null);
    });
    on<_Deleted>((event, emit) async {
      var successOrFailure = await localRepository.deleteCity(
          CityNameAndFavorite(
              cityName: event.cityWeather.getCityNameOrThrow(),
              favorite: event.cityWeather.favorite));

      emit(successOrFailure
          .fold((failure) => CitiesOverviewState.weatherRetrieveError(failure),
              (success) {
        citiesWeather.removeWhere((city) =>
            city.getCityNameOrThrow() ==
            event.cityWeather.getCityNameOrThrow());
        return CitiesOverviewState.weatherRetrieveSuccess(citiesWeather);
      }));
    });
  }
}

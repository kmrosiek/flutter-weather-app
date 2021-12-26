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

@singleton
class CitiesOverviewBloc
    extends Bloc<CitiesOverviewEvent, CitiesOverviewState> {
  final IRemoteRepository weatherClient;
  final ILocalRepository localRepository;

  CitiesOverviewBloc(
      {required this.weatherClient, required this.localRepository})
      : super(CitiesOverviewState.initial()) {
    on<_FetchData>((event, emit) async {
      Either<RepositoryFailure, List<CityNameAndFavorite>> citiesOrFailure =
          await localRepository.loadCityList();

      await citiesOrFailure.fold(
          (failure) async => emit(state.copyWith(
              repositoryFailure: some(failure),
              isLoading: false)), (cities) async {
        var citiesFutures = cities
            .map((city) => CityWeather.create(
                cityName: city.cityName, favor: city.favorite))
            .toList();

        var futures = Future.wait(citiesFutures);
        var citiesWeather = (await futures).toList();
        var indexOfInvalid =
            citiesWeather.indexWhere((cityWeather) => !cityWeather.isValid());
        emit(indexOfInvalid == -1
            ? state.copyWith(citiesWeather: citiesWeather, isLoading: false)
            : state.copyWith(
                isLoading: false,
                repositoryFailure:
                    some(citiesWeather[indexOfInvalid].getFailureOrThrow())));
      });
    });

    on<_FavoriteSwitched>((event, emit) async {
      (await localRepository.saveCity(CityNameAndFavorite(
              cityName: event.cityWeather.getCityNameOrThrow(),
              favorite: event.cityWeather.favorite)))
          .fold(
              (failure) => emit(CitiesOverviewState.initial()
                  .copyWith(repositoryFailure: some(failure))), (_) {
        var indexOfSwitchedCity = state.citiesWeather.indexWhere((city) =>
            city.getCityNameOrThrow() ==
            event.cityWeather.getCityNameOrThrow());
        if (-1 == indexOfSwitchedCity) {
          emit(CitiesOverviewState.initial().copyWith(
              repositoryFailure:
                  some(const RepositoryFailure.invalidDatabaseStructure())));
          return;
        }
        //citiesWeather[indexOfSwitchedCity].favorite =
        //event.cityWeather.favorite;
        //TODO
      });
    });
    on<_Deleted>((event, emit) async {
      var successOrFailure = await localRepository.deleteCity(
          CityNameAndFavorite(
              cityName: event.cityWeather.getCityNameOrThrow(),
              favorite: event.cityWeather.favorite));

      emit(successOrFailure
          .fold((failure) => state.copyWith(repositoryFailure: some(failure)),
              (success) {
        var citiesWeather = List<CityWeather>.from(state.citiesWeather);
        citiesWeather.removeWhere((city) =>
            city.getCityNameOrThrow() ==
            event.cityWeather.getCityNameOrThrow());
        return state.copyWith(citiesWeather: citiesWeather);
      }));
    });

    on<_Added>((event, emit) async {
      var cities = List<CityWeather>.from(state.citiesWeather);
      var indexOfEdited = cities.indexWhere((city) =>
          city.getCityNameOrThrow() == event.cityWeather.getCityNameOrThrow());
      if (indexOfEdited == -1) {
        cities.add(event.cityWeather);
        emit(state.copyWith(citiesWeather: cities));
      } else {
        //emit(state.copyWith(
        //repositoryFailure: some(const RepositoryFailure.unexpected())));
        //TODO should notify user city is already in the list
      }
    });

    on<_Edited>((event, emit) async {
      var cities = List<CityWeather>.from(state.citiesWeather);
      var indexOfEdited = cities.indexWhere((city) =>
          city.getCityNameOrThrow() == event.oldCity.getCityNameOrThrow());
      if (indexOfEdited == -1) {
        emit(state.copyWith(
            repositoryFailure: some(const RepositoryFailure.unexpected())));
        return;
      }
      var indexOfNew = cities.indexWhere((city) =>
          city.getCityNameOrThrow() == event.newCity.getCityNameOrThrow());
      if (indexOfNew != -1) {
        //TODO should notify user city is already in the list
      }
      cities[indexOfEdited] = event.newCity;
      emit(state.copyWith(citiesWeather: cities));
    });
  }
}

import 'package:dartz/dartz.dart' show none;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/application/add_edit_city/add_edit_city_bloc.dart';
import 'package:weatherapp/application/cities_overview/cities_overview_bloc.dart';
import 'package:weatherapp/injection.dart';
import 'package:weatherapp/presentation/add_edit_city_page.dart';
import 'package:weatherapp/presentation/widgets/weather_tile.dart';

class CitiesOverviewPage extends StatelessWidget {
  const CitiesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities Overview'),
        actions: [
          BlocBuilder<CitiesOverviewBloc, CitiesOverviewState>(
              builder: (context, state) => IconButton(
                  onPressed: () => getIt<CitiesOverviewBloc>()
                      .add(const CitiesOverviewEvent.switchSort()),
                  icon: Icon(state.sortedByFavorite
                      ? Icons.favorite
                      : Icons.favorite_border))),
          const SizedBox(width: 16.0)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => getIt<AddEditCityBloc>(),
                    child: AddEditCityPage(cityWeatherOption: none()),
                  )));
        },
        tooltip: 'Add city',
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CitiesOverviewBloc, CitiesOverviewState>(
          builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var selectedCities = state.sortedByFavorite
            ? state.citiesWeather.where((city) => city.favorite).toList()
            : state.citiesWeather;

        if (state.repositoryFailure.isSome() || selectedCities.isEmpty) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Icon(Icons.image_not_supported, size: 60),
                const SizedBox(height: 12.0),
                if (state.repositoryFailure.isNone())
                  const Text('No weather to show'),
                Text(state.repositoryFailure.fold(() => '', (failure) {
                  return failure.maybeMap(
                      invalidArgument: (_) => 'Weather values are out of range',
                      noInternet: (_) => 'No Internet Access',
                      invalidDatabaseStructure: (_) => 'Internal Storage Error',
                      orElse: () => 'Unexpected Error');
                })),
              ]));
        }
        return ListView.separated(
          itemCount: selectedCities.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return WeatherTile(
              cityWeather: selectedCities[index],
            );
          },
        );
      }),
    );
  }
}

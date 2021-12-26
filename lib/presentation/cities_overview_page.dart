import 'package:dartz/dartz.dart' show none;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/application/add_edit_city/add_edit_city_bloc.dart';
import 'package:weatherapp/application/cities_overview/cities_overview_bloc.dart';
import 'package:weatherapp/injection.dart';
import 'package:weatherapp/presentation/add_edit_city_page.dart';
import 'package:weatherapp/presentation/widgets/weather_tile.dart';

class CitiesOverview extends StatefulWidget {
  const CitiesOverview({Key? key}) : super(key: key);

  @override
  _CitiesOverviewState createState() => _CitiesOverviewState();
}

class _CitiesOverviewState extends State<CitiesOverview> {
  List<String> words = List.generate(30, (index) => 'Word $index');
  List<String> savedWords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities Overview'),
        actions: const [Icon(Icons.sort)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => getIt<AddEditCityBloc>(),
                    child: AddEditCityPage(cityWeatherOption: none()),
                  )));
        },
        tooltip: 'Add city',
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CitiesOverviewBloc, CitiesOverviewState>(
          //listenWhen: (p, c) => p.repositoryFailure != c.repositoryFailure,
          listener: (context, state) => null,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.repositoryFailure.isSome() ||
                state.citiesWeather.isEmpty) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const Icon(Icons.image_not_supported, size: 60),
                    const SizedBox(height: 12.0),
                    if (state.repositoryFailure.isNone())
                      const Text('No weather saved yet.'),
                    Text(state.citiesWeather.isEmpty
                        ? 'No weather saved yet.'
                        : state.repositoryFailure.fold(() => 'Unexpected error',
                            (failure) {
                            return failure.maybeMap(
                                noInternet: (_) => 'No Internet Access',
                                orElse: () => 'Unexpected error');
                          })),
                  ]));
            }
            var cities = state.citiesWeather;
            print('rebuild');
            return Column(
              children: [
                ElevatedButton(
                    onPressed: () => context
                        .read<CitiesOverviewBloc>()
                        .add(CitiesOverviewEvent.deleted(cities[0])),
                    child: Text('Remove')),
                Expanded(
                  child: ListView.separated(
                    itemCount: cities.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      String word = cities[index].getCityNameOrThrow();
                      bool isSaved = savedWords.contains(word);
                      return WeatherTile(
                          cityWeather: cities[index],
                          word: word,
                          isSaved: isSaved,
                          onTap: () {
                            setState(() {
                              if (isSaved) {
                                savedWords.remove(word);
                              } else {
                                savedWords.add(word);
                                context.read<CitiesOverviewBloc>().add(
                                    CitiesOverviewEvent.favoriteSwitched(
                                        cities[index]));
                              }
                            });
                          });
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

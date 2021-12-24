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
      body: BlocBuilder<CitiesOverviewBloc, CitiesOverviewState>(
        builder: (context, state) {
          const Widget loading = Center(child: CircularProgressIndicator());
          return state.map(
              initial: (_) => loading,
              loading: (_) => loading,
              weatherRetrieveError: (error) {
                return error.repositoryFailure.maybeMap(
                    notFound: (_) => Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                              Icon(Icons.image_not_supported, size: 60),
                              SizedBox(height: 12.0),
                              Text('No weather saved yet.')
                            ])),
                    orElse: () => const Center(
                          child: Text('Could not fetch the weather.'),
                        ));
              },
              weatherRetrieveSuccess: (response) {
                var cities = response.citiesWeather;
                return ListView.separated(
                  itemCount: cities.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    String word = cities[index].getCityNameOrThrow();
                    bool isSaved = savedWords.contains(word);
                    return WeatherTile(
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
                );
              },
              favoriteSwitchFailure: (failure) {
                return const Text('what the heck');
              });
        },
      ),
    );
  }
}

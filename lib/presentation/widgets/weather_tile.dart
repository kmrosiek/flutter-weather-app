import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/application/add_edit_city/add_edit_city_bloc.dart';
import 'package:weatherapp/application/cities_overview/cities_overview_bloc.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/injection.dart';
import 'package:weatherapp/presentation/add_edit_city_page.dart';
import 'package:weatherapp/presentation/weather_details_page.dart';
import 'package:weatherapp/presentation/utils.dart';

class WeatherTile extends StatelessWidget {
  final CityWeather cityWeather;

  const WeatherTile({
    Key? key,
    required this.cityWeather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WeatherDetailsPage(cityWeather: cityWeather))),
      title: Text(cityWeather.getCityNameOrThrow().toFirstCapital()),
      leading: IconButton(
        icon: Icon(
            cityWeather.favorite ? Icons.favorite : Icons.favorite_border,
            color: cityWeather.favorite ? Colors.red : null),
        onPressed: () => context
            .read<CitiesOverviewBloc>()
            .add(CitiesOverviewEvent.favoriteSwitched(cityWeather)),
      ),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => getIt<AddEditCityBloc>(),
                      child:
                          AddEditCityPage(cityWeatherOption: some(cityWeather)),
                    ))),
            icon: const Icon(Icons.edit)),
        const SizedBox(width: 12),
        IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete))
      ]),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deleting city from the list'),
          content: Text(
            'Selected city: ${cityWeather.getCityNameOrThrow().toFirstCapital()}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                getIt<CitiesOverviewBloc>()
                    .add(CitiesOverviewEvent.deleted(cityWeather));
                Navigator.pop(context);
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }
}

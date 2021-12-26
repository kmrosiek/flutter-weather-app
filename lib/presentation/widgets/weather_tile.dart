import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/application/add_edit_city/add_edit_city_bloc.dart';
import 'package:weatherapp/application/cities_overview/cities_overview_bloc.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/injection.dart';
import 'package:weatherapp/presentation/add_edit_city_page.dart';

class WeatherTile extends StatelessWidget {
  final String word;
  final bool isSaved;
  final CityWeather cityWeather;
  final void Function() onTap;

  const WeatherTile(
      {Key? key,
      required this.word,
      required this.isSaved,
      required this.cityWeather,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word),
      leading: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : null,
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
      onTap: onTap,
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deleting city from the list'),
          content: Text(
            'Selected city: ${cityWeather.getCityNameOrThrow()}',
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

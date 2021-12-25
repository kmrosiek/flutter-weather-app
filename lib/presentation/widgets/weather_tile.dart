import 'package:flutter/material.dart';
import 'package:weatherapp/application/cities_overview/cities_overview_bloc.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/injection.dart';

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
        const Icon(Icons.edit),
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

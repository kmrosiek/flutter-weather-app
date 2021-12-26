import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/domain/data_models/weather.dart';
import 'package:weatherapp/domain/data_models/weather_value_objects.dart';
import 'package:weatherapp/domain/repositories/repository_failures.dart';
import 'package:weatherapp/presentation/utils.dart';

class WeatherDetailsPage extends StatelessWidget {
  final CityWeather cityWeather;

  const WeatherDetailsPage({
    Key? key,
    required this.cityWeather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Weather weather = cityWeather.value
        .getOrElse(() => throw const RepositoryFailure.unexpected());
    final List<Temperature> dailyTemperatures = weather.dailyTemps.value
        .getOrElse(() => throw const RepositoryFailure.unexpected());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather details'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cityWeather.getCityNameOrThrow().toFirstCapital()),
              Text('Temperature: ${weather.getTemperatureOrThrow}'),
              Text('Pressure: ${weather.getPressureOrThrow}'),
              Text('Humidity: ${weather.getHumidityOrThrow}'),
              Text('Wind Speed: ${weather.getWindSpeedOrThrow}'),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: generateDays(dailyTemperatures),
              ),
            ],
          )),
    );
  }

  List<Widget> generateDays(List<Temperature> daily) {
    List<Widget> widgets = [];
    DateTime today = DateTime.now();
    for (var temp in daily) {
      today.add(const Duration(days: 1));
      widgets.add(SizedBox(
          height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat('dd-mm-yyyy').format(today)),
              Text(temp.getValueOrThrow),
            ],
          )));
    }
    return widgets;
  }
}

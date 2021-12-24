import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weatherapp/application/add_edit_city/add_edit_city_bloc.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';

class AddEditCityPage extends HookWidget {
  const AddEditCityPage({Key? key, required this.cityWeatherOption})
      : super(key: key);

  final Option<CityWeather> cityWeatherOption;

  @override
  Widget build(BuildContext context) {
    final cityController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(cityWeatherOption.isSome() ? 'Edit' : 'Add'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Enter City'),
                controller: cityController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<AddEditCityBloc>().add(
                      AddEditCityEvent.cityNameSubmitted(cityController.text));
                },
                child: const Text('Submit')),
            BlocBuilder<AddEditCityBloc, AddEditCityState>(
                builder: (context, state) {
              return state.maybeWhen(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  weatherRetrieveError: (failure) => Text(failure.maybeMap(
                      noInternet: (_) => 'No Internet Access',
                      orElse: () => 'Other error')),
                  weatherRetrieveSuccess: () => const Text("Success"),
                  orElse: () => Container());
            })
          ],
        ),
      ),
    );
  }
}

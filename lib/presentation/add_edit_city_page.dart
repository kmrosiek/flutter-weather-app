import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weatherapp/application/add_edit_city/add_edit_city_bloc.dart';
import 'package:weatherapp/application/cities_overview/cities_overview_bloc.dart';
import 'package:weatherapp/domain/data_models/city_weather.dart';
import 'package:weatherapp/injection.dart';

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
            BlocConsumer<AddEditCityBloc, AddEditCityState>(
                listener: (context, state) => state.maybeMap(
                    submissionSuccess: (s) {
                      getIt<CitiesOverviewBloc>().add(
                          CitiesOverviewEvent.addedOrEdited(s.cityWeather));
                      Navigator.pop(context);
                    },
                    orElse: () {}),
                builder: (context, state) {
                  return state.maybeWhen(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      submissionFailure: (failure) => Text(failure.maybeMap(
                          notFound: (_) => 'City could not be found',
                          noInternet: (_) => 'No Internet Access',
                          orElse: () => 'Other error')),
                      submissionSuccess: (_) => const Text("Success"),
                      orElse: () => Container());
                })
          ],
        ),
      ),
    );
  }
}

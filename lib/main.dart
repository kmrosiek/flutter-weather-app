import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weatherapp/presentation/cities_overview_page.dart';

import 'application/cities_overview/cities_overview_bloc.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => getIt<CitiesOverviewBloc>()
          ..add(const CitiesOverviewEvent.fetchData()),
        child: const CitiesOverview(),
      ),
    );
  }
}

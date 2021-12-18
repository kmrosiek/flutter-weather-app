import 'package:weatherapp/infrastructure/data_models/coordinates_dto.dart';

abstract class IAPIClient {
  Future<Coordinates> getCityCoordinates(String city);
}

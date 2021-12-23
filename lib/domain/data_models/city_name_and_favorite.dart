import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_name_and_favorite.freezed.dart';

@freezed
class CityNameAndFavorite with _$CityNameAndFavorite {
  const factory CityNameAndFavorite(
      {required String cityName,
      required bool favorite}) = _CityNameAndFavorite;
}

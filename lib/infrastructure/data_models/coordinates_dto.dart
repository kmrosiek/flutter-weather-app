// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinates_dto.freezed.dart';
part 'coordinates_dto.g.dart';

@freezed
class Coordinates with _$Coordinates {
  //TODO how to do this more efficiently - without Coord class? nested jsonKey?
  const factory Coordinates({
    required Coord coord,
  }) = _Coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}

@freezed
class Coord with _$Coord {
  @JsonSerializable(explicitToJson: true)
  const factory Coord({
    @JsonKey(name: 'lat') required double latitude,
    @JsonKey(name: 'lon') required double longitude,
  }) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

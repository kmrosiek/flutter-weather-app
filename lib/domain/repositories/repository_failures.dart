import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_failures.freezed.dart';

@freezed
class RepositoryFailure with _$RepositoryFailure {
  const factory RepositoryFailure.notFound() = _NotFound;
  const factory RepositoryFailure.noInternet() = _noInternet;
  const factory RepositoryFailure.invalidArgument() = _InvalidArgument;
  const factory RepositoryFailure.insufficientPermission() =
      _InsufficientPermission;
  const factory RepositoryFailure.invalidDatabaseStructure() =
      _InvalidDatabaseStructure;
  const factory RepositoryFailure.unexpected() = _Unexpected;
}

part of 'add_edit_city_bloc.dart';

@freezed
class AddEditCityState with _$AddEditCityState {
  const factory AddEditCityState.initial() = _Initial;
  const factory AddEditCityState.loading() = _Loading;
  const factory AddEditCityState.submissionFailure(
      RepositoryFailure repositoryFailure) = _SubmissionFailure;
  const factory AddEditCityState.submissionSuccess(CityWeather cityWeather) =
      _SubmissionSuccess;
}

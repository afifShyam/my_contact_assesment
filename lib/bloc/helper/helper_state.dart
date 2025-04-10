part of 'helper_cubit.dart';

@freezed
abstract class HelperState with _$HelperState {
  const factory HelperState({
    required ContactFilter filter,
    required String searchQuery,
  }) = _HelperState;

  factory HelperState.initial() => HelperState(
        filter: ContactFilter.all,
        searchQuery: '',
      );
}

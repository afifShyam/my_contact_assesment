part of 'contact_bloc.dart';

enum ContactStateStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
sealed class ContactState with _$ContactState {
  factory ContactState({
    required ContactStateStatus status,
    required Pagination<ContactModel> contacts,
    String? errorMessage,
  }) = _ContactState;

  factory ContactState.initial() => ContactState(
        status: ContactStateStatus.initial,
        contacts: Pagination<ContactModel>.initial(),
        errorMessage: null,
      );

  factory ContactState.fromJson(Map<String, dynamic> json) => _$ContactStateFromJson(json);
}

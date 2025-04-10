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
    required ContactStateStatus addStatus,
    required ContactStateStatus deleteStatus,
    required ContactStateStatus updateStatus,
    required Pagination<ContactModel> contacts,
    required List<ContactModel> favcontacts,
    String? errorMessage,
  }) = _ContactState;

  factory ContactState.initial() => ContactState(
        status: ContactStateStatus.initial,
        addStatus: ContactStateStatus.initial,
        deleteStatus: ContactStateStatus.initial,
        updateStatus: ContactStateStatus.initial,
        contacts: Pagination<ContactModel>.initial(),
        favcontacts: [],
        errorMessage: null,
      );

  factory ContactState.fromJson(Map<String, dynamic> json) => _$ContactStateFromJson(json);
}

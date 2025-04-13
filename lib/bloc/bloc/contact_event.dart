part of 'contact_bloc.dart';

@freezed
sealed class ContactEvent with _$ContactEvent {
  const factory ContactEvent.addContact({
    required String email,
    required String firstName,
    required String lastName,
    String? avatar,
  }) = AddContact;
  const factory ContactEvent.updateContact({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    String? avatar,
  }) = UpdateContact;
  const factory ContactEvent.deleteContact(
    int id,
  ) = DeleteContact;
  const factory ContactEvent.searchContact(
    String query,
  ) = SearchContact;
  const factory ContactEvent.favouriteContact({
    required int id,
    required bool isFavourite,
  }) = FavouriteContact;
  const factory ContactEvent.sortContact(
    SortingContact sorting,
  ) = SortContact;
  const factory ContactEvent.loadContacts({
    @Default(1) int page,
  }) = LoadContacts;
  const factory ContactEvent.sendEmail({
    required String email,
    required String subject,
    required String body,
  }) = SendEmail;
}

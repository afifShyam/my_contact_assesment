part of 'contact_bloc.dart';

@freezed
class ContactEvent with _$ContactEvent {
  const factory ContactEvent.addContact(
    String email,
    String firstName,
    String lastName,
    String avatar,
  ) = AddContact;
  const factory ContactEvent.updateContact(
    int id,
  ) = UpdateContact;
  const factory ContactEvent.deleteContact(
    int id,
  ) = DeleteContact;
  const factory ContactEvent.searchContact(
    String query,
  ) = SearchContact;
  const factory ContactEvent.favouriteContact(
    bool isFavourite,
  ) = FavouriteContact;
  const factory ContactEvent.sortContact(
    SortingContact sorting,
  ) = SortContact;
  const factory ContactEvent.loadContacts(
    int page,
  ) = LoadContacts;
}

import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:my_contact/model/contact_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_contact/model/pagination.dart';
import 'package:my_contact/repositories/contact_repo.dart';
import 'package:my_contact/utils/index.dart';

part 'contact_bloc.freezed.dart';
part 'contact_bloc.g.dart';
part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends HydratedBloc<ContactEvent, ContactState> {
  final ContactRepository _contactRepository;
  ContactBloc({
    required ContactRepository contactRepository,
  })  : _contactRepository = contactRepository,
        super(ContactState.initial()) {
    on<LoadContacts>(_loadContacts);
    // on<UpdateContact>(_updateContact);
    // on<DeleteContact>(_deleteContact);
    // on<SearchContact>(_searchContact);
    // on<FavouriteContact>(_favouriteContact);
    // on<SortContact>(_sortContact);
    // on<AddContact>(_addContact);
  }

  Future<void> _loadContacts(LoadContacts event, Emitter<ContactState> emit) async {
    try {
      emit(state.copyWith(status: ContactStateStatus.loading));

      final result = await _contactRepository.fetchContacts(event.page);

      List<ContactModel> contacts = event.page >= 2 ? [...state.contacts.data] : [];

      emit(
        ContactState(
          contacts: state.contacts.copyWith(
            data: [
              ...contacts,
              ...result.data,
            ],
          ),
          status: ContactStateStatus.success,
        ),
      );
    } catch (e) {
      log('Error loading contacts: $e');
      emit(state.copyWith(status: ContactStateStatus.failure, errorMessage: e.toString()));
    }
  }

  @override
  ContactState? fromJson(Map<String, dynamic> json) {
    return ContactState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ContactState state) {
    return state.toJson();
  }
}

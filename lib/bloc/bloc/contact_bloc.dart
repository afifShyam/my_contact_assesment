import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:my_contact/model/contact_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_contact/model/pagination.dart';
import 'package:my_contact/repositories/contact_repo.dart';
import 'package:my_contact/utils/index.dart';
import 'package:url_launcher/url_launcher.dart';

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
    on<AddContact>(_addContact);
    on<DeleteContact>(_deleteContact);
    on<UpdateContact>(_updateContact);
    on<SendEmail>(_sendEmail);
    on<FavouriteContact>(_favouriteContact);
  }

  Future<void> _loadContacts(LoadContacts event, Emitter<ContactState> emit) async {
    try {
      emit(state.copyWith(status: ContactStateStatus.loading));

      final result = await _contactRepository.fetchContacts(event.page);

      List<ContactModel> contacts = event.page >= 2 ? [...state.contacts.data] : [];

      emit(
        state.copyWith(
          contacts: result.copyWith(
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
      emit(
        state.copyWith(
          status: ContactStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _addContact(AddContact event, Emitter<ContactState> emit) async {
    try {
      emit(state.copyWith(addStatus: ContactStateStatus.loading));

      final result = await _contactRepository.addContact(
        event.email,
        event.firstName,
        event.lastName,
        event.avatar ?? '',
      );

      emit(
        state.copyWith(
          contacts: state.contacts.copyWith(
            data: [
              ...state.contacts.data,
              result,
            ],
          ),
          addStatus: ContactStateStatus.success,
        ),
      );
    } catch (e) {
      log('Error adding contact: $e');
      emit(
        state.copyWith(
          addStatus: ContactStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _deleteContact(DeleteContact event, Emitter<ContactState> emit) async {
    try {
      emit(state.copyWith(status: ContactStateStatus.loading));

      await _contactRepository.deleteContact(event.id);

      final updatedData = List<ContactModel>.from(state.contacts.data)
        ..removeWhere((contact) => contact.id == event.id);

      emit(
        state.copyWith(
          contacts: state.contacts.copyWith(
            data: updatedData,
          ),
          status: ContactStateStatus.success,
        ),
      );
    } catch (e) {
      log('Error deleting contact: $e');
      emit(
        state.copyWith(
          status: ContactStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _updateContact(
    UpdateContact event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(updateStatus: ContactStateStatus.loading));

      final data = await _contactRepository.updateContact(
        id: event.id,
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        avatar: event.avatar,
      );

      final updatedList = List<ContactModel>.from(state.contacts.data.map((contact) {
        return contact.id == event.id ? data : contact;
      }));

      emit(state.copyWith(
        contacts: state.contacts.copyWith(
          data: updatedList,
        ),
        updateStatus: ContactStateStatus.success,
      ));
    } catch (e) {
      log('Error updating contact: $e');
      emit(
        state.copyWith(
          updateStatus: ContactStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _sendEmail(SendEmail event, Emitter emit) async {
    try {
      emit(state.copyWith(status: ContactStateStatus.loading));

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: event.email,
        queryParameters: {
          'subject': event.subject,
          'body': event.body,
        },
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        emit(state.copyWith(status: ContactStateStatus.success));
      } else {
        throw Exception('Could not launch email client');
      }
    } catch (e) {
      log('Error sending email: $e');
      emit(state.copyWith(
        status: ContactStateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _favouriteContact(FavouriteContact event, Emitter<ContactState> emit) async {
    try {
      emit(state.copyWith(status: ContactStateStatus.loading));

      emit(state.copyWith(
        contacts: state.contacts.copyWith(
          data: state.contacts.data.map((contact) {
            if (contact.id == event.id) {
              return contact.copyWith(isFav: event.isFavourite);
            }
            return contact;
          }).toList(),
        ),
        status: ContactStateStatus.success,
      ));
    } catch (e) {
      log('Error favourite contact: $e');
      emit(
        state.copyWith(
          status: ContactStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
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

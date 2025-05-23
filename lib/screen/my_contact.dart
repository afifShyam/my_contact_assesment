import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_contact/bloc/index.dart';
import 'package:my_contact/model/contact_model.dart';
import 'package:my_contact/utils/index.dart';

class MyContact extends StatefulWidget {
  const MyContact({super.key});

  @override
  State<MyContact> createState() => _MyContactState();
}

class _MyContactState extends State<MyContact> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onDismissed(BuildContext context, ContactModel contact) {
    showCupertinoDialog<String>(
      context: context,
      builder: (dialogCtx) => CupertinoAlertDialog(
        title: const Text("Delete Contact"),
        content: Text(
          'Are you sure you want to delete "${contact.firstName} ${contact.lastName}" from your contact?',
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("No"),
            onPressed: () => Navigator.pop(dialogCtx, "Cancel"),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Delete"),
            onPressed: () {
              context.read<ContactBloc>().add(DeleteContact(contact.id));
              Navigator.pop(dialogCtx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helper = context.watch<HelperCubit>().state;
    final filter = helper.filter;
    final query = helper.searchQuery.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Contacts',
          style: TextStyleShared.textStyle.title.copyWith(color: Colors.white),
        ),
        backgroundColor: ContactColor.primarydark,
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final state = context.read<ContactBloc>().state;

          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
              state.contacts.hasNextPage &&
              state.status != ContactStateStatus.loading) {
            context.read<ContactBloc>().add(LoadContacts(page: state.contacts.page + 1));
          }
          return false;
        },
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, _) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: TabHeader(
                minSize: 150,
                maxSize: 150,
                child: ColoredBox(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          onChanged: (search) => context.read<HelperCubit>().setSearchQuery(search),
                          onTapOutside: (_) {
                            _searchController.clear();
                            _searchFocus.unfocus();
                          },
                          decoration: const InputDecoration(
                            labelText: 'Search Contact',
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: ContactFilter.values.map((type) {
                            final isSelected = helper.filter == type;
                            final label = type == ContactFilter.all ? 'All' : 'Favourite';
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(label),
                                selected: isSelected,
                                selectedColor: Colors.pink[700],
                                backgroundColor: Colors.grey[200],
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSelected: (_) => context.read<HelperCubit>().toggleFilter(type),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: RefreshIndicator.adaptive(
            onRefresh: () async {
              context.read<ContactBloc>().add(LoadContacts());
            },
            child: BlocBuilder<ContactBloc, ContactState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.updateStatus != current.updateStatus ||
                  previous.addStatus != current.addStatus,
              builder: (context, state) {
                if (state.status == ContactStateStatus.loading && state.contacts.data.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final baseList = filter == ContactFilter.all
                    ? state.contacts.data
                    : state.contacts.data.where((c) => c.isFav).toList();

                final filteredContacts = baseList.where((contact) {
                  final firstName = contact.firstName.toLowerCase();
                  final lastName = contact.lastName.toLowerCase();
                  final fullName = '$firstName $lastName';
                  final email = contact.email.toLowerCase();
                  final queryLower = query.toLowerCase();
                  return firstName.contains(queryLower) ||
                      lastName.contains(queryLower) ||
                      fullName.contains(queryLower) ||
                      email.contains(queryLower);
                }).toList();

                if (filteredContacts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/no_contact.png',
                          scale: 1.5,
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          'Looks like your contact list is empty. Add a new contact now.',
                          style: TextStyleShared.textStyle.title,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: state.contacts.hasNextPage
                      ? filteredContacts.length + 1
                      : filteredContacts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    if (index == filteredContacts.length) {
                      return const CupertinoActivityIndicator();
                    }
                    final contact = filteredContacts[index];
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: contact.isFav ? Colors.grey : Colors.purple,
                            icon: contact.isFav ? Icons.favorite : Icons.favorite_border,
                            label: 'Fav',
                            onPressed: (context) {
                              context.read<ContactBloc>().add(
                                    FavouriteContact(
                                      id: contact.id,
                                      isFavourite: !contact.isFav,
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.yellow,
                            icon: Icons.edit_square,
                            label: 'Edit',
                            onPressed: (_) {
                              context.go(
                                '/edit-contact',
                                extra: {
                                  'contactBloc': context.read<ContactBloc>(),
                                  'contact': contact,
                                },
                              );
                            },
                          ),
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                            onPressed: (_) => _onDismissed(context, contact),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: contact.image != null
                                  ? (contact.image!.startsWith('http')
                                      ? CachedNetworkImageProvider(contact.image!)
                                      : FileImage(File(contact.image!)) as ImageProvider)
                                  : const AssetImage('assets/images/default_avatar.png'),
                            ),
                            if (contact.isFav)
                              const Positioned(
                                bottom: 0,
                                right: -2,
                                child: Icon(
                                  Icons.star_rounded,
                                  color: Color.fromARGB(255, 255, 162, 53),
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                        title: SelectableText('${contact.firstName} ${contact.lastName}'),
                        subtitle: SelectableText(contact.email),
                        trailing: GestureDetector(
                          onTap: () {
                            context.go(
                              '/send-email',
                              extra: {
                                'contactBloc': context.read<ContactBloc>(),
                                'contact': contact,
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/images/paperplane.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
            '/add-contact',
            extra: {
              'contactBloc': context.read<ContactBloc>(),
            },
          );
        },
        backgroundColor: ContactColor.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

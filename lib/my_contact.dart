import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_contact/addContact.dart';
import 'package:my_contact/bloc/bloc/contact_bloc.dart';
import 'package:my_contact/sendemail.dart';

enum ContactFilter { all, favourite }

class MyContact extends StatefulWidget {
  const MyContact({super.key});

  @override
  State<MyContact> createState() => _MyContactState();
}

class _MyContactState extends State<MyContact> {
  // late Future<List<Contact>> _contactFuture;

  final TextEditingController _searchController = TextEditingController();
  ContactFilter _currentFilter = ContactFilter.all;

  @override
  void initState() {
    super.initState();
    // _contactFuture = fetchContacts();
  }

  // Future<List<Contact>> fetchContacts() async {
  //   var url = 'https://reqres.in/api/users?page=1';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final List data = jsonDecode(response.body)['data'];
  //     _allContacts = data.map((contact) => Contact.fromJson(contact)).toList();
  //     return _allContacts;
  //   } else {
  //     throw Exception('Failed to fetch contacts');
  //   }
  // }

  // Future<void> _deleteContact(int id) async {
  //   try {
  //     final response = await http.delete(Uri.parse('https://reqres.in/api/users/$id'));

  //     if (response.statusCode == 204) {
  //       setState(() {
  //         _allContacts.removeWhere((contact) => contact.id == id);
  //         _filteredContacts.removeWhere((contact) => contact.id == id);
  //       });
  //     } else {
  //       throw Exception('Failed to delete contact');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // void _navigateToUpdateContact(Contact contact) async {
  //   final updatedContact = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Profile(
  //         contactId: contact.id,
  //         initialEmail: contact.email,
  //         initialFirstName: contact.firstName,
  //         initialLastName: contact.lastName,
  //         initialAvatar: contact.image,
  //       ),
  //     ),
  //   );

  //   if (updatedContact != null) {
  //     setState(() {
  //       // Find and update the contact in the list
  //       final index = _allContacts.indexWhere((c) => c.id == updatedContact.id);
  //       if (index != -1) {
  //         _allContacts[index] = updatedContact;
  //       }
  //     });
  //   }
  // }

  // void _toggleFilter(ContactFilter newFilter) {
  //   setState(() {
  //     _currentFilter = newFilter;
  //   });
  // }

  // void _onSearchTextChanged(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       _filteredContacts.clear();
  //     });
  //   } else {
  //     setState(() {
  //       _filteredContacts = _allContacts.where((contact) {
  //         final fullName = '${contact.firstName} ${contact.lastName}';
  //         return fullName.toLowerCase().contains(query.toLowerCase());
  //       }).toList();
  //     });
  //   }
  // }

  // void _refreshContacts() {
  //   setState(() {
  //     _contactFuture = fetchContacts();
  //     _searchController.clear();
  //     _filteredContacts.clear();
  //   });
  // }

  // void _onDismissed(Contact contact) {
  //   showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Delete Contact"),
  //         content: const Text("Are you sure you want to delete this contact?"),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Yes"),
  //             onPressed: () {
  //               _deleteContact(contact.id);
  //               setState(() {
  //                 _allContacts.remove(contact);
  //                 _filteredContacts.remove(contact);
  //               });
  //               Navigator.pop(context);
  //             },
  //           ),
  //           TextButton(
  //             child: const Text("No"),
  //             onPressed: () {
  //               Navigator.pop(context, "Cancel");
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _toggleFavorite(Contact contact) {
  //   setState(() {
  //     final index = _allContacts.indexOf(contact);
  //     _allContacts[index].isFav = !_allContacts[index].isFav;
  //     if (_filteredContacts.contains(contact)) {
  //       final filteredIndex = _filteredContacts.indexOf(contact);
  //       _filteredContacts[filteredIndex].isFav = !_filteredContacts[filteredIndex].isFav;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Contacts'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: Color.fromARGB(255, 73, 182, 167),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {}, //_refreshContacts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _searchController,
          //     onChanged: _onSearchTextChanged,
          //     decoration: const InputDecoration(
          //       labelText: 'Search',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(25.0)),
          //       ),
          //     ),
          //   ),
          // ),
          // ToggleButtons(
          //   isSelected: [
          //     _currentFilter == ContactFilter.all,
          //     _currentFilter == ContactFilter.favourite,
          //   ],
          //   onPressed: (index) {
          //     setState(() {
          //       if (index == 0) {
          //         _toggleFilter(ContactFilter.all);
          //         _filteredContacts.clear();
          //       } else if (index == 1) {
          //         _toggleFilter(ContactFilter.favourite);
          //         _filteredContacts = _allContacts.where((contact) => contact.isFav).toList();
          //       }
          //     });
          //   },
          //   children: const [Text('All'), Text('Fav')],
          // ),
          BlocBuilder<ContactBloc, ContactState>(
            builder: (context, state) {
              if (state.status == ContactStateStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return switch (state.contacts.data.isEmpty) {
                true => const Center(child: Text('No contacts')),
                false => ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.contacts.data.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final contact = state.contacts.data[index];
                      return Slidable(
                        startActionPane: ActionPane(motion: const StretchMotion(), children: [
                          SlidableAction(
                            backgroundColor: contact.isFav ? Colors.grey : Colors.purple,
                            icon: contact.isFav ? Icons.favorite : Icons.favorite_border,
                            label: 'Fav',
                            onPressed: (context) => () {}, // _toggleFavorite(contact),
                          ),
                        ]),
                        endActionPane: ActionPane(motion: const StretchMotion(), children: [
                          SlidableAction(
                            backgroundColor: Colors.yellow,
                            icon: Icons.edit_square,
                            label: 'Edit',
                            onPressed: (context) {
                              // _navigateToUpdateContact(contact);
                            },
                          ),
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                            onPressed: (context) => () {}, // _onDismissed(contact),
                          ),
                        ]),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(contact.image ??
                                'https://cdn-icons-png.flaticon.com/512/149/149045.png'),
                          ),
                          title: Text("${contact.firstName} ${contact.lastName}"),
                          subtitle: Text(contact.email),
                          trailing: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => sendEmail(
                              //       contactId: contact.id,
                              //       initialEmail: contact.email,
                              //       initialFirstName: contact.firstName,
                              //       initialLastName: contact.lastName,
                              //       initialAvatar: contact.image ??
                              //           'https://cdn-icons-png.flaticon.com/512/149/149045.png',
                              //     ),
                              //   ),
                              // );
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
                  )
              };
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => addPage(
          //       onContactAdded: (newContact) {
          //         setState(() {
          //           // _allContacts.add(newContact);
          //         });
          //       },
          //     ),
          //   ),
          // );
        },
        backgroundColor: Color.fromARGB(255, 73, 182, 167),
        shape: const CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}

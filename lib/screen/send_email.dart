import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_contact/bloc/bloc/contact_bloc.dart';
import 'package:my_contact/model/contact_model.dart';
import 'package:my_contact/utils/index.dart';

class SendEmailPage extends StatelessWidget {
  final ContactModel contact;

  const SendEmailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ContactColor.primarydark,
        title: Text(
          'Send Email',
          style: TextStyleShared.textStyle.title.copyWith(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Column(
          spacing: 16,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: contact.image != null
                      ? (contact.image!.startsWith('http')
                          ? NetworkImage(contact.image!)
                          : FileImage(File(contact.image!)) as ImageProvider)
                      : const AssetImage('assets/images/default_avatar.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: -2,
                  child: Icon(
                    Icons.star_rounded,
                    color: Color.fromARGB(255, 255, 162, 53),
                    size: 40,
                  ),
                ),
              ],
            ),
            Text(
              '${contact.firstName} ${contact.lastName}',
              style: TextStyleShared.textStyle.title.copyWith(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Chip(
              label: Text('Edit Profile',
                  style: TextStyleShared.textStyle.button.copyWith(
                    color: ContactColor.primary,
                  )),
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(
                color: ContactColor.primary,
                width: 2,
              ),
              backgroundColor: ContactColor.primary.withValues(alpha: .25),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Icon(Icons.email),
                  Text(contact.email),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  context.read<ContactBloc>().add(SendEmail(
                        email: contact.email,
                        subject: 'Hi, hope you hired me!',
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ContactColor.primary,
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Send Email',
                    style: TextStyleShared.textStyle.button.copyWith(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:my_contact/bloc/index.dart';
import 'package:my_contact/model/contact_model.dart';
import 'package:my_contact/utils/index.dart';

class Profile extends StatefulWidget {
  final ContactModel contact;
  final bool isEdit;

  const Profile({
    super.key,
    required this.contact,
    required this.isEdit,
  });

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.contact.email;
    _fnameController.text = widget.contact.firstName;
    _lnameController.text = widget.contact.lastName;
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _updateContact() {
    if (_formKey.currentState!.validate()) {
      final contactId = widget.contact.id;
      final email = _emailController.text;
      final fname = _fnameController.text;
      final lname = _lnameController.text;
      final avatar = _selectedImage?.path;

      if (widget.isEdit) {
        context.read<ContactBloc>().add(
              UpdateContact(
                id: contactId,
                email: email,
                firstName: fname,
                lastName: lname,
                avatar: avatar?.isEmpty ?? true ? widget.contact.image : avatar,
              ),
            );
      } else {
        context.read<ContactBloc>().add(
              AddContact(
                email: email,
                firstName: fname,
                lastName: lname,
                avatar: avatar,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ContactColor.primarydark,
        title: Text(
          widget.isEdit ? 'Edit Contact' : 'Profile',
          style: TextStyleShared.textStyle.title.copyWith(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) {
          Navigator.pop(context);
          if (widget.isEdit) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Contact updated successfully'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Contact added successfully'),
              ),
            );
          }
        },
        listenWhen: (previous, current) =>
            previous.updateStatus == ContactStateStatus.loading &&
                current.updateStatus == ContactStateStatus.success ||
            previous.addStatus == ContactStateStatus.loading &&
                current.addStatus == ContactStateStatus.success,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.file(
                            _selectedImage!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          radius: 70,
                          backgroundImage: widget.contact.image != null
                              ? (widget.contact.image!.startsWith('http')
                                  ? NetworkImage(widget.contact.image!)
                                  : FileImage(File(widget.contact.image!)) as ImageProvider)
                              : const AssetImage('assets/images/default_avatar.png'),
                        ),
                ),
                _buildRoundedInput(_fnameController, 'First Name', 'Enter your first name'),
                _buildRoundedInput(_lnameController, 'Last Name', 'Enter your last name'),
                _buildRoundedInput(_emailController, 'Email', 'Enter your email address'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _updateContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ContactColor.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    widget.isEdit ? 'Edit' : 'Save',
                    style: TextStyleShared.textStyle.button.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedInput(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ContactColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: ContactColor.primary.withValues(alpha: .4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: ContactColor.primary.withValues(alpha: .4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: ContactColor.primary, width: 1.8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label'.toLowerCase();
            }
            return null;
          },
        ),
      ],
    );
  }
}

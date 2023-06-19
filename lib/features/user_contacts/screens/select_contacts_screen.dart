// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/user_contacts/controller/select_contacts_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});

  static const routeName = '/selct-contacts-screen';

  void selectContact({
    required BuildContext context,
    required WidgetRef ref,
    required Contact selectedContact,
  }) {
    ref.read(SelectContactControllerProvider).selectContact(
          context: context,
          selectedContact: selectedContact,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contacts'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  Contact contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(
                      context: context,
                      ref: ref,
                      selectedContact: contact,
                    ),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 30,
                            ),
                    ),
                  );
                },
              ),
            ),
            error: (error, stackTrace) => ErrorWidget(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final selectContactsRepositoriesProvider = Provider(
  (ref) => SelectContactsRepositories(FirebaseFirestore.instance),
);

class SelectContactsRepositories {
  final FirebaseFirestore firestore;

  SelectContactsRepositories(this.firestore);

  getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission() != false) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      return contacts;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void selectContact({
    required Contact selectedContact,
    required BuildContext context,
  }) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        debugPrint(selectedPhoneNum);
        debugPrint(userData.phoneNumber);

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          break;
        }
      }
      if (!isFound) {
        showsnackbar(ctx: context, msg: 'This contact does not exist');
      }
    } catch (e) {
      showsnackbar(ctx: context, msg: e.toString());
    }
  }
}

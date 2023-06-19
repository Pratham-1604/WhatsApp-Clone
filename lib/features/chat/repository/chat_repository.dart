import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository(
    this.firestore,
    this.auth,
  );

  void _saveDataToContactSubCollection({
    required UserModel senderUserData,
    required UserModel receiverUserData,
    required String lastMessage,
    required DateTime timeSent,
    required String receiverUserId,
  }) async {
    // users -> receiverId -> chats -> current user id -> set data
    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.phoneNumber,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    // users -> current user id -> chats -> receiverId -> set data
    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.phoneNumber,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderData,
  }) async {
    try {
      var timeSent = DateTime.now();
      // users -> sender user id -> receiver user id -> messages -> message id -> text

      UserModel receiverData;
      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      receiverData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactSubCollection(
        senderUserData: senderData,
        receiverUserData: receiverData,
        lastMessage: text,
        timeSent: timeSent,
        receiverUserId: receiverId,
      );
    } catch (e) {
      showsnackbar(
        ctx: context,
        msg: e.toString(),
      );
    }
  }
}

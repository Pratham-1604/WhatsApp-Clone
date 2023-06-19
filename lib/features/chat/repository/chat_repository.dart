import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final ChatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  ),
);

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

  void _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required receiverUsername,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: receiverUserId,
      text: text,
      type: MessageEnum.text,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    // users -> sender user id -> receiver user id -> messages -> message id -> text
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // users -> receiver user id -> sender user id -> messages -> message id -> text
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderUserData,
  }) async {
    try {
      var timeSent = DateTime.now();

      UserModel receiverData;
      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      receiverData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactSubCollection(
        senderUserData: senderUserData,
        receiverUserData: receiverData,
        lastMessage: text,
        timeSent: timeSent,
        receiverUserId: receiverId,
      );

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        receiverUsername: receiverData.name,
        messageType: MessageEnum.text,
      );
    } catch (e) {
      showsnackbar(
        ctx: context,
        msg: e.toString(),
      );
    }
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/widgets/my_message_card.dart';
import 'package:whatsapp_clone/widgets/sender_message_card.dart';

class ChatLists extends StatelessWidget {
  const ChatLists({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (messages[index]['isMe'] == true) {
          // my message card
          return MyMessageCard(
            message: messages[index]['text'].toString(),
            time: messages[index]['time'].toString(),
          );
        }
        // sender message card
        return SenderMessageCard(
          message: messages[index]['text'].toString(),
          time: messages[index]['time'].toString(),
        );
      },
      itemCount: messages.length,
    );
  }
}

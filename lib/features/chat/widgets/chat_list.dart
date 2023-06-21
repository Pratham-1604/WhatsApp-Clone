// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controllet.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/widgets/my_message_card.dart';
import 'package:whatsapp_clone/widgets/sender_message_card.dart';

class ChatLists extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatLists({
    required this.receiverUserId,
    super.key,
  });

  @override
  ConsumerState<ChatLists> createState() => _ChatListsState();
}

class _ChatListsState extends ConsumerState<ChatLists> {
  final ScrollController messageController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref.read(chatControllerProvider).chatStream(
              receiverUserId: widget.receiverUserId,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            messageController.jumpTo(
              messageController.position.maxScrollExtent,
            );
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId != widget.receiverUserId) {
                // my message card
                return MyMessageCard(
                  message: messageData.text,
                  time: timeSent,
                );
              }
              // sender message card
              return SenderMessageCard(
                message: messageData.text,
                time: timeSent,
              );
            },
          );
        });
  }
}

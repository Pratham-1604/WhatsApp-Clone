// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information.dart';
import 'package:whatsapp_clone/features/user_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/screens/mobile_chat_screen.dart';

import 'features/auth/screens/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case OTPScreen.routeName:
      final verificationID = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationID,
        ),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case MobileChatScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileChatScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: const ErrorScreen(error: 'This page does not exist'),
        ),
      );
  }
}

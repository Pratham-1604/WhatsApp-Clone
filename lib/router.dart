// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';

import 'features/auth/screens/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case OTPScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const OTPScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: const ErrorScreen(error: 'This page does not exist'),
        ),
      );
  }
}

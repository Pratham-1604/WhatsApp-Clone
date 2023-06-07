// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.error,
  });

  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(error),
    );
  }
}

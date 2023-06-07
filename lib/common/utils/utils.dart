// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

void showsnackbar({required BuildContext ctx, required String msg}) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

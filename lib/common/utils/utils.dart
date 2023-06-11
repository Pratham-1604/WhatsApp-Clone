// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showsnackbar({required BuildContext ctx, required String msg}) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

Future<File?> addPhoto(BuildContext context) async {
  File? image;

  try {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
    return image;
  } catch (e) {
    showsnackbar(ctx: context, msg: e.toString());
  }
}

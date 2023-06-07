import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository(
    this.auth,
    this.firestore,
  );

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showsnackbar(ctx: context, msg: e.message!);
    }
  }
}

import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/view_model/auth/signup_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class FirebaseHelper {
  static Future<UserModel?> fetchUserData({required String userId}) async {
    UserModel? userData;
    DocumentSnapshot docsSnap =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (docsSnap.data() != null) {
      userData = UserModel.fromMap(docsSnap.data() as Map<String, dynamic>);
    }
    return userData;
  }

  static Future<UserCredential?> createUserwithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;
    debugPrint("inside create Account: fireBaseHelper");
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    signUpProvider.setExceptionStatus(status: true);
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      signUpProvider.setExceptionStatus(status: false);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        signUpProvider.setExceptionStatus(status: true);
        ShowDialogModel.alertDialog(context, "Error", Text(e.code.toString()), [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              signUpProvider.setExceptionStatus(status: false);
            },
            child: const Text("close"),
          ),
        ]);
      }
    }
    return userCredential;
    // userId = userCredential.user!.uid;
  }

  static String? _phoneVerficationId;

  static void verfyPhone({
    required String phone,
  }) async {
    String inputPhoneNumber = "+91$phone";
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: inputPhoneNumber,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {},
      codeSent: (verificationId, forceResendingToken) {
        _phoneVerficationId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 20),
    );
  }

  static Future<UserCredential?> verifyOtp({
    required String otp,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _phoneVerficationId!,
      smsCode: otp,
    );

    try {
      userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ShowDialogModel.alertDialog(context, "Error", Text(e.code.toString()), [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("close"),
          ),
        ]);
      }
    }
    return userCredential;
  }

  static Future<UserCredential?> loginWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ShowDialogModel.alertDialog(context, "Error", Text(e.code.toString()), [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("close"),
          ),
        ]);
      }
    }

    return userCredential;
  }

  static storeUserData({
    required UserModel userData,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userData.userId)
        .set(userData.toMap());
  }

  static Future<String> uploadDataToFirebaseStorage(
      {required File imageFile, required UserModel userData}) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepicture")
        .child(userData.userId.toString())
        .putFile(imageFile);
    TaskSnapshot uploadTaskSnapshot = await uploadTask;
    return await uploadTaskSnapshot.ref.getDownloadURL();
  }
}

import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/view_model/auth/signin_provider.dart';
import 'package:chat_app/view_model/auth/signup_provider.dart';
import 'package:chat_app/view_model/home/chatspace_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../model/message_model.dart';
import '../utils/utils.dart';

class FirebaseHelper {
  static final firebaseInstance = FirebaseAuth.instance;

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
      debugPrint("inside try");
      userCredential = await firebaseInstance.createUserWithEmailAndPassword(
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
    debugPrint("return from firebase");
    return userCredential;
    // userId = userCredential.user!.uid;
  }

  static String? _phoneVerficationId;

  static Future<void> verfyPhone({
    required String phone,
    required BuildContext context,
  }) async {
    String inputPhoneNumber = "+91$phone";
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);

    try {
      
      if (phone.length != 10) {
        signInProvider.setExceptionOccuredStatus(status: true);
      signUpProvider.setExceptionStatus(status: true);
        throw FirebaseAuthException(code: "Enter 10-digits Phone number!");
      }
      await firebaseInstance.verifyPhoneNumber(
        phoneNumber: inputPhoneNumber,
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {},
        codeSent: (verificationId, forceResendingToken) {
          _phoneVerficationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 20),
      );
      signInProvider.setExceptionOccuredStatus(status: false);
      signUpProvider.setExceptionStatus(status: false);
      debugPrint("${signInProvider.isExceptionOccured}insidehelper");
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        signUpProvider.setExceptionStatus(status: true);
        ShowDialogModel.alertDialog(context, "Error", Text(e.code.toString()), [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              signUpProvider.setExceptionStatus(status: false);
              signInProvider.setExceptionOccuredStatus(status: false);
            },
            child: const Text("close"),
          ),
        ]);
      }
    }
  }

  static Future<UserCredential?> verifyOtp({
    required String otp,
    required BuildContext context,
  }) async {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    UserCredential? userCredential;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _phoneVerficationId!,
      smsCode: otp,
    );
    try {
      signInProvider.setExceptionOccuredStatus(status: true);
      signUpProvider.setExceptionStatus(status: true);
      userCredential = await firebaseInstance.signInWithCredential(
        credential,
      );
      signInProvider.setExceptionOccuredStatus(status: false);
      signUpProvider.setExceptionStatus(status: false);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ShowDialogModel.alertDialog(context, "Error", Text(e.code.toString()), [
          TextButton(
            onPressed: () {
              signInProvider.setExceptionOccuredStatus(status: false);
              signUpProvider.setExceptionStatus(status: false);
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
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);

    try {
      signInProvider.setExceptionOccuredStatus(status: true);
      userCredential = await firebaseInstance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      signInProvider.setExceptionOccuredStatus(status: false);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ShowDialogModel.alertDialog(context, "Error", Text(e.code.toString()), [
          TextButton(
            onPressed: () {
              signInProvider.setExceptionOccuredStatus(status: false);
              Navigator.of(context).pop();
            },
            child: const Text("close"),
          ),
        ]);
      }
    }

    return userCredential;
  }

  static Future<void> storeUserData({
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchCollection(
      {required String collectionName}) {
    return FirebaseFirestore.instance.collection(collectionName).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      fetchDataStreamFromCollection({
    required String collectionName,
    required Object whereClauseField,
    bool isTwoWhereClauses = false,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    bool? isNull,
    Object? whereClauseField2,
    Object? isEqualTo2,
    Object? isNotEqualTo2,
    Object? isLessThan2,
    Object? isLessThanOrEqualTo2,
    Object? isGreaterThan2,
    Object? isGreaterThanOrEqualTo2,
    Object? arrayContains2,
    bool? isNull2,
  }) {
    return (!isTwoWhereClauses)
        ? FirebaseFirestore.instance
            .collection(collectionName)
            .where(
              whereClauseField,
              isEqualTo: isEqualTo,
              isNotEqualTo: isNotEqualTo,
              isLessThan: isLessThan,
              isLessThanOrEqualTo: isLessThanOrEqualTo,
              isGreaterThan: isGreaterThan,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              arrayContains: arrayContains,
              isNull: isNull,
              arrayContainsAny: arrayContainsAny,
            )
            .snapshots()
        : FirebaseFirestore.instance
            .collection(collectionName)
            .where(
              whereClauseField,
              isEqualTo: isEqualTo,
              isNotEqualTo: isNotEqualTo,
              isLessThan: isLessThan,
              isLessThanOrEqualTo: isLessThanOrEqualTo,
              isGreaterThan: isGreaterThan,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              arrayContains: arrayContains,
              isNull: isNull,
            )
            .where(
              whereClauseField2!,
              isEqualTo: isEqualTo2,
              isNotEqualTo: isNotEqualTo2,
              isLessThan: isLessThan2,
              isLessThanOrEqualTo: isLessThanOrEqualTo2,
              isGreaterThan: isGreaterThan2,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo2,
              arrayContains: arrayContains2,
              isNull: isNull2,
            )
            .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessages({
    required String chatSpaceId,
  }){
    return FirebaseFirestore.instance
                  .collection("chatspace")
                  .doc(chatSpaceId)
                  .collection("messages")
                  .orderBy("createdOn", descending: true)
                  .snapshots();
  }
  
}

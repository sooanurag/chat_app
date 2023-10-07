import 'dart:io';

import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_helper.dart';
import '../../view_model/user_provider.dart';

Future<String?> uploadDataToStorageRepo({
  required File imageFile,
  required BuildContext context,
}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  String? imageFileURL;

  try {
    imageFileURL = await FirebaseHelper.uploadDataToFirebaseStorage(
        imageFile: imageFile, userData: userProvider.userData);
  } catch (e) {
    if(context.mounted){
    ShowDialogModel.alertDialog(
        context, "Warning", const Text("Firebase storage bucket quota exceeded!"), [
      TextButton(
          onPressed: () {
            
              Navigator.pop(context);
            
          },
          child: const Text("Close"))
    ]);}
  }
  return imageFileURL;
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_helper.dart';
import '../../view_model/user_provider.dart';

Future<String> uploadDataToStorageRepo({
    required File imageFile,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String imageFileURL = await FirebaseHelper.uploadDataToFirebaseStorage(
        imageFile: imageFile, userData: userProvider.userData);
    return imageFileURL;
  }
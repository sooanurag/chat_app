import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpProvider with ChangeNotifier {
  
  bool _isExceptionOccured = false;
  bool get isExceptionOccured => _isExceptionOccured;
  void setExceptionStatus({required bool status}) {
    _isExceptionOccured = status;
    notifyListeners();
  }

  bool _emailPasswordValidator = true;
  bool get emailPasswordValidator => _emailPasswordValidator;
  void setemailPasswordValidatorStatus({required bool status}) {
    _emailPasswordValidator = status;
    notifyListeners();
  }

  bool _isPhoneEnabled = true;
  bool get isPhoneEnabled => _isPhoneEnabled;
  void setPhoneEnableStatus({required bool status}) {
    _isPhoneEnabled = status;
    notifyListeners();
  }

  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;
  void setEnableStatus({required bool status}) {
    _isEnabled = status;
    notifyListeners();
  }

  bool _isAccountCreated = false;
  bool get isAccountCreated => _isAccountCreated;
  void setAccountCreateStatus(bool status) {
    _isAccountCreated = status;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoadingStatus(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  bool _isPhone = true;
  bool get isPhone => _isPhone;
  void setPhoneStatus(bool status) {
    _isPhone = status;
    notifyListeners();
  }

  String _buttonTitle = "Sign Up";
  String get buttonTitle => _buttonTitle;
  void setButtonValue({required String buttonTitle}) {
    _buttonTitle = buttonTitle;
    notifyListeners();
  }

  Future<void> createAccountWithEmailPassowrd({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    debugPrint("inside createAccount : Provider");

    UserCredential? userCredential =
        await FirebaseHelper.createUserwithEmailPassword(
      email: email,
      password: password,
      context: context,
    );
    if (userCredential != null) {
      userProvider.setUserData(
        userData: UserModel(
          userId: userCredential.user!.uid,
          emailId: email,
        ),
      );
      FirebaseHelper.storeUserData(
        userData: userProvider.userData,
      );
    }
  }

  void verifyPhone({required String phone,required BuildContext context}) {
    FirebaseHelper.verfyPhone(phone: phone,context: context,);
  }

  Future<void> createAccountWithPhone({
    required BuildContext context,
    required String phone,
    required String otp,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserCredential? userCredential = await FirebaseHelper.verifyOtp(
      otp: otp,
      context: context,
    );

    if (userCredential != null) {
      userProvider.setUserData(
        userData: UserModel(
          userId: userCredential.user!.uid,
          phoneNumber: phone,
        ),
      );
      FirebaseHelper.storeUserData(
        userData: userProvider.userData,
      );
    }
  }

  Future<void> updateUserData({
    required BuildContext context,
    String? firstName,
    String? lastName,
    String? profilePicture,
    bool? activeStatus,
    bool? isPinned,
    bool? isArchived,
    String? info,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel updateUser = userProvider.userData;
    updateUser.fullName = '${firstName?.trim()} ${lastName?.trim()}';
    updateUser.profilePicture =
        profilePicture?.trim() ?? updateUser.profilePicture;
    updateUser.activeStatus = activeStatus ?? updateUser.activeStatus;
    updateUser.isPinned = isPinned ?? updateUser.isPinned;
    updateUser.isArchived = isArchived ?? updateUser.isArchived;
    updateUser.info = info?.trim() ?? updateUser.info;

    userProvider.setUserData(userData: updateUser);

    FirebaseHelper.storeUserData(userData: userProvider.userData);
  }

  Future<String> uploadDataToStorage({
    required File imageFile,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String imageFileURL = await FirebaseHelper.uploadDataToFirebaseStorage(
        imageFile: imageFile, userData: userProvider.userData);
    return imageFileURL;
  }
}

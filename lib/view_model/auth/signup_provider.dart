import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpProvider with ChangeNotifier {
  bool _isAccountCreated = false;
  bool _isSuccess = false;
  bool _isPhone = true;
  String _buttonTitle = "Sign Up";
  bool _isEnabled = true;
  bool _isPhoneEnabled = true;
  bool _emailPasswordValidator = true;

  bool get emailPasswordValidator => _emailPasswordValidator;
  void setemailPasswordValidatorStatus({required bool status}) {
    _emailPasswordValidator = status;
    notifyListeners();
  }

  bool get isPhoneEnabled => _isPhoneEnabled;
  void setPhoneEnableStatus({required bool status}) {
    _isPhoneEnabled = status;
    notifyListeners();
  }

  bool get isEnabled => _isEnabled;
  void setEnableStatus({required bool status}) {
    _isEnabled = status;
    notifyListeners();
  }

  bool get isAccountCreated => _isAccountCreated;
  void setAccountCreateStatus(bool status) {
    _isAccountCreated = status;
    notifyListeners();
  }

  bool get isSuccess => _isSuccess;
  void setSuccessStatus(bool status) {
    _isSuccess = status;
    notifyListeners();
  }

  bool get isPhone => _isPhone;
  void setPhoneStatus(bool status) {
    _isPhone = status;
    notifyListeners();
  }

  String get buttonTitle => _buttonTitle;
  void setButtonValue({required String buttonTitle}) {
    _buttonTitle = buttonTitle;
    notifyListeners();
  }

  void createAccountWithEmailPassowrd({
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

  void verifyPhone({required String phone}) {
    FirebaseHelper.verfyPhone(phone: phone);
  }

  void createAccountWithPhone({
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

  void updateUserData({
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

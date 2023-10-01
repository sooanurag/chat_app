import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/repository/firebase_repo/update_userdata.dart';
import 'package:chat_app/repository/firebase_repo/upload_firestore.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/routes/route_names.dart';
import '../../utils/utils.dart';

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

    UserCredential? userCredential =
        await FirebaseHelper.createUserwithEmailPassword(
      email: email,
      password: password,
      context: context,
    );
    if (userCredential != null) {
      userProvider.setUserData(
        userData: UserModel(
          firebaseUser: userCredential.user as User,
          userId: userCredential.user!.uid,
          emailId: email,
        ),
      );
      FirebaseHelper.storeUserData(
        userData: userProvider.userData,
      );
    }
  }

  void verifyPhone({required String phone, required BuildContext context}) {
    FirebaseHelper.verfyPhone(
      phone: phone,
      context: context,
    );
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
          firebaseUser: userCredential.user,
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
    await updateUserDataRepo(
      context: context,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      activeStatus: activeStatus,
      isArchived: isArchived,
      isPinned: isPinned,
      info: info,
    );
  }

  Future<String> uploadDataToStorage({
    required File imageFile,
    required BuildContext context,
  }) async {
    return await uploadDataToStorageRepo(
      imageFile: imageFile,
      context: context,
    );
  }

  Future<void> onPressSignUpForm({
    required signUpFormKey,
    required value,
    required BuildContext context,
    required emailController,
    required passwordController,
    required phoneController,
    required otpController,
    required signUpProvider,
    required timerFuction,
  }) async {

    debugPrint(signUpFormKey.currentState!.validate().toString());
    if (value.buttonTitle == "Sign Up" || value.buttonTitle == "Verify") {
      if (signUpFormKey.currentState!.validate()) {
        debugPrint(value.buttonTitle);
        (value.buttonTitle == "Sign Up")
            ? await value.createAccountWithEmailPassowrd(
                context: context,
                email: emailController.text,
                password: passwordController.text,
              )
            : await value.createAccountWithPhone(
                context: context,
                phone: phoneController.text,
                otp: otpController.text,
              );
        if (!signUpProvider.isExceptionOccured) {
          value.setAccountCreateStatus(true);
          timerFuction();
        }
      }
    } else if (value.buttonTitle == "Send OTP") {
      if (signUpFormKey.currentState!.validate()) {
        value.verifyPhone(
          phone: phoneController.text,
          context: context,
        );
      }
      signUpProvider.setPhoneStatus(false);
      signUpProvider.setButtonValue(buttonTitle: "Verify");
    }
  }

  Future<void> onPressCompleteProfileForm({
    required completeProfileKey,
    required signUpProvider,
    required BuildContext context,
    required firstNameController,
    required lastNameController,
    required aboutController,
  }) async {
    if (completeProfileKey.currentState!.validate()) {
      signUpProvider.updateUserData(
        context: context,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        info: aboutController.text,
        profilePicture: (Utils.imageFile.value != null)
            ? await signUpProvider.uploadDataToStorage(
                imageFile: Utils.imageFile.value!, context: context)
            : null,
      );
      debugPrint("saved user data");
      if(context.mounted){
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacementNamed(context, RouteName.home);}
    }
  }
}

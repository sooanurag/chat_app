import 'package:chat_app/services/firebase_helper.dart';
import 'package:chat_app/utils/routes/route_names.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';

class SignInProvider with ChangeNotifier {
  bool _isExceptionOccured = false;
  bool get isExceptionOccured => _isExceptionOccured;
  void setExceptionOccuredStatus({required bool status}) {
    _isExceptionOccured = status;
    notifyListeners();
  }

  bool _isSignInWithPhone = true;
  bool get isSignInWithPhone => _isSignInWithPhone;
  void setSignInWithPhoneStatus({required bool status}) {
    _isSignInWithPhone = status;
    notifyListeners();
  }

  bool _isSignInWithEmail = true;
  bool get isSignInWithEmail => _isSignInWithEmail;
  void setSignInWithEmailStatus({required bool status}) {
    _isSignInWithEmail = status;
    notifyListeners();
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserCredential? userCredential =
        await FirebaseHelper.loginWithEmailPassword(
      email: email.trim(),
      password: password.trim(),
      context: context,
    );

    if (userCredential != null) {
      UserModel? userData = await FirebaseHelper.fetchUserData(
        userId: userCredential.user!.uid,
      );
      userData!.firebaseUser = userCredential.user;
      debugPrint(userData.fullName);
      userProvider.setUserData(userData: userData);
    }
  }

  Future<void> verifyPhone(
      {required String phone, required BuildContext context}) async {
    FirebaseHelper.verfyPhone(
      phone: phone.trim(),
      context: context,
    );
  }

  Future<void> signInWithPhone({
    required String otp,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserCredential? userCredential = await FirebaseHelper.verifyOtp(
      otp: otp.trim(),
      context: context,
    );

    if (userCredential != null) {
      UserModel? userData =
          await FirebaseHelper.fetchUserData(userId: userCredential.user!.uid);
      userData!.firebaseUser = userCredential.user;
      debugPrint(userData.fullName);
      userProvider.setUserData(userData: userData);
    }
  }

  Future<void> onPress({
    required buttonValue,
    required isSendOTP,
    required emailController,
    required passwordController,
    required phoneController,
    required otpController,
    required BuildContext context,
  }) async {
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    debugPrint(buttonValue.value);

    if (buttonValue.value == "Sign In") {
      debugPrint("call signInWithEmail");
      await signInProvider.signInWithEmailPassword(
        email: emailController.text,
        password: passwordController.text,
        context: context,
      );
      if (!signInProvider.isExceptionOccured) {
        debugPrint("sign In success");
        if (context.mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, RouteName.home);
        }
      }
    } else if (buttonValue.value == "Send OTP") {
      await signInProvider.verifyPhone(
        phone: phoneController.text,
        context: context,
      );
      debugPrint(signInProvider.isExceptionOccured.toString());
      if (!signInProvider.isExceptionOccured) {
        isSendOTP.value = true;
        buttonValue.value = "Verify OTP";
      }
    } else if (buttonValue.value == "Verify OTP") {
      await signInProvider.signInWithPhone(
        otp: otpController.text,
        context: context,
      );
      if (!signInProvider.isExceptionOccured) {
        debugPrint("signed-In with Phone");
        if (context.mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, RouteName.home);
        }
      }
    }
  }
}

import 'package:flutter/material.dart';

class SignUpProvider with ChangeNotifier {
  bool _isAccountCreated = false;
  bool _isSuccess = false;

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
}

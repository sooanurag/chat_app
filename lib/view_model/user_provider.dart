import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel _userData = UserModel();

  get userData => _userData;
  void setUserData({required UserModel userData}) {
    _userData = userData;
    notifyListeners();
  }
}

import 'package:chat_app/model/chatspace_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel _userData = UserModel();

  UserModel get userData => _userData;
  void setUserData({required UserModel userData}) {
    _userData = userData;
    notifyListeners();
  }

  UserModel _targetUserData = UserModel();
  UserModel get targetuserData => _targetUserData;
  void setTargetUserData({required UserModel targetUserData}) {
    _targetUserData = targetUserData;
    notifyListeners();
  }

}

import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  listenToUserStatus({
    required BuildContext context,
  }) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    FirebaseFirestore.instance
        .collection("users")
        .doc(userProvider.targetuserData.userId)
        .snapshots()
        .listen((event) {
      UserModel targetUser = UserModel.fromMap(event.data()!);
      (targetUser.activeStatus!)
          ? userProvider.targetuserData.activeStatus = true
          : userProvider.targetuserData.activeStatus = false;
      notifyListeners();
    });
  }
}

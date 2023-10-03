import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../services/firebase_helper.dart';
import '../../view_model/user_provider.dart';

Future<void> updateUserDataRepo({
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
  updateUser.userNameListForSearch = getList(fullName: firstName!);

  userProvider.setUserData(userData: updateUser);

  FirebaseHelper.storeUserData(userData: userProvider.userData);
}

getList({
  required String fullName,
}) {
  List<String> list = [];
  String val = "";
  for (int i = 0; i < fullName.length / 2; i++) {
    list.add(fullName[i]);
    val = val + fullName[i];
    list.add(val);
  }
  return list;
}

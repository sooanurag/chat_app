import 'package:chat_app/model/chatspace_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:chat_app/view_model/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProvider with ChangeNotifier {
  initiatedUsersStream({
    required BuildContext context,
  }) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel userData = userProvider.userData;

    return FirebaseHelper.fetchDataStreamFromCollection(
      collectionName: "chatspace",
      whereClauseField: "participants.${userData.userId}",
      isEqualTo: true,
    );
  }

  fetchTargetUserIdFromChatSpace(
      {required ChatSpaceModel chatSpaceData, required String userId}) {
    List<String> keys = chatSpaceData.participants!.keys.toList();
    keys.remove(userId);
    return keys[0];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsersFromCollection() {
    return FirebaseHelper.fetchCollection(collectionName: "users");
  }
}

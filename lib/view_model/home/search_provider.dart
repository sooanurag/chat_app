import 'package:chat_app/repository/firebase_repo/create_chatspace.dart';
import 'package:chat_app/repository/firebase_repo/fetch_existing_chatspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/chatspace_model.dart';
import '../../services/firebase_helper.dart';

class SearchProvider with ChangeNotifier {
  bool _isSearching = false;
  get isSearching => _isSearching;
  setisSearchingStatus({required bool status}) {
    _isSearching = status;
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsersFromCollection(
      {required String userId}) {
    return FirebaseHelper.fetchDataStreamFromCollection(
        collectionName: "users",
        whereClauseField: "userId",
        isNotEqualTo: userId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      fetchUsersFromCollectionUsingFullName({required String inputString}) {
    return FirebaseHelper.fetchDataStreamFromCollection(
      collectionName: "users",
      whereClauseField: "userNameListForSearch",
      arrayContainsAny: [inputString],
    );
  }

  Future<ChatSpaceModel> fetchChatSpace({
    required String userId,
    required String targetUserId,
  }) async {
    if (userId == targetUserId) {
      throw FirebaseException(
          plugin: "This feature will available in future updates!");
    }
    ChatSpaceModel chatSpace;
    ChatSpaceModel? existingModel = await fetchExistingChatSpace(
        userId: userId, targetUserId: targetUserId);
    if (existingModel == null) {
      chatSpace = await createChatSpace(
        userId: userId,
        targetUserId: targetUserId,
      );
    } else {
      chatSpace = existingModel;
    }
    return chatSpace;
  }
}

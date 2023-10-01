import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
}

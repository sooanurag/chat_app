import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  User? firebaseUser;
  String? userId;
  String? fullName;
  String? emailId;
  String? profilePicture;
  String? phoneNumber;
  bool? activeStatus;
  bool? isPinned;
  bool? isArchived;
  String? info;
  List<String>? userNameListForSearch;

  UserModel({
    this.userId,
    this.firebaseUser,
    this.fullName,
    this.emailId,
    this.profilePicture,
    this.phoneNumber,
    this.activeStatus = false,
    this.isArchived = false,
    this.isPinned = false,
    this.info,
    
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    userId = map["userId"];
    fullName = map["fullName"];
    emailId = map["emailId"];
    phoneNumber = map["phoneNumber"];
    profilePicture = map["profilePicture"];
    activeStatus = map["activeStatus"];
    isArchived = map["isArchived"];
    isPinned = map["isPinned"];
    info = map["info"];
    
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "fullName": fullName,
      "emailId": emailId,
      "phoneNumber": phoneNumber,
      "profilePicture": profilePicture,
      "activeStatus": activeStatus,
      "isArchived": isArchived,
      "isPinned": isPinned,
      "info": info,
      "userNameListForSearch": userNameListForSearch,
      
    };
  }
}

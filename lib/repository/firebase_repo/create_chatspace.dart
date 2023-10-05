import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/chatspace_model.dart';

Future<ChatSpaceModel> createChatSpace({
  required String userId,
  required String targetUserId,
}) async {
  ChatSpaceModel newChatSpace = ChatSpaceModel(
    chatSpaceId: Utils.uuid.v1(),
    lastMessage: "- Say hi!",
    participants: {
      userId: true,
      targetUserId: true,
    },
    unseenCounter: {
      userId : 0,
      targetUserId : 0,
    },
    whichChatSpaceUserActive: {
      userId : true,
      targetUserId : false,
    },
    unseenMessagesList: {
      userId:[],
      targetUserId:[],
    }
    

  );

  await FirebaseFirestore.instance
      .collection("chatspace")
      .doc(newChatSpace.chatSpaceId)
      .set(newChatSpace.toMap());

  return newChatSpace;
}

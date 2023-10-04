import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/chatspace_model.dart';

Future<ChatSpaceModel> createChatSpace({
  required String userId,
  required String targetUserId,
}) async {
  ChatSpaceModel newChatSpace = ChatSpaceModel(
    chatSpaceId: Utils.uuid.v1(),
    lastMessage: "",
    participants: {
      userId: true,
      targetUserId: true,
    },
  );

  await FirebaseFirestore.instance
      .collection("chatspace")
      .doc(newChatSpace.chatSpaceId)
      .set(newChatSpace.toMap());

  return newChatSpace;
}
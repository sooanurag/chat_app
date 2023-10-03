
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/chatspace_model.dart';

Future<ChatSpaceModel?> fetchExistingChatSpace({
  required String userId,
  required String targetUserId,
}) async {
  ChatSpaceModel? existingModel;
  QuerySnapshot fetechedModel = await FirebaseFirestore.instance
      .collection("chatspace")
      .where(
        "participants.$userId",
        isEqualTo: true,
      )
      .where(
        "participants.$targetUserId",
        isEqualTo: true,
      )
      .get();
  if (fetechedModel.docs.isNotEmpty) {
    dynamic modelMap = fetechedModel.docs[0].data();
    existingModel = ChatSpaceModel.fromMap(modelMap);
  }
  return existingModel;
}

import 'dart:async';

import 'package:chat_app/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chatspace_provider.dart';

class MessageStreamProvider with ChangeNotifier {
  initStreamAndStore({
    required BuildContext context,
    required String chatSpaceId,
    required String userId,
  })  {
    // final streamProvider =
    //     Provider.of<MessageStreamProvider>(context, listen: false);

    final helperProvider =
        Provider.of<ChatSpaceProvider>(context, listen: false);
    Stream<QuerySnapshot<Map<String, dynamic>>> myStream =  helperProvider
        .fetchMessagesStream(chatSpaceId: chatSpaceId, context: context, );

    helperProvider.emptyMessageStateList();
    myStream.listen((event) {
      helperProvider.emptyMessageStateList();

      for (QueryDocumentSnapshot<Map<String, dynamic>> queryDocSnapshot
          in event.docs) {
         
                MessageModel messageModel =
                    MessageModel.fromMap(queryDocSnapshot.data());
                if (messageModel.deleteForMeCheck?[userId] == true) {
                  helperProvider.setNewMessageStateList(
                      messageData: messageModel);
                }
              
      }
      notifyListeners();
    });
  }

  bool _isHold = false;
  bool get isHold => _isHold;
  void setIsHold({required bool status}) {
    _isHold = status;
    notifyListeners();
  }
}

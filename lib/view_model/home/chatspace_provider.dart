import 'package:chat_app/model/chatspace_model.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/message_model.dart';
import '../../utils/utils.dart';

class ChatSpaceProvider with ChangeNotifier {
  List<MessageModel> _messageStateList = [];
  List<MessageModel> get messageStatesList => _messageStateList;
  void emptyMessageStateList() => _messageStateList = [];
  void setNewMessageStateList({
    required MessageModel messageData,
  }) {
    _messageStateList.add(messageData);
  }

  void updateMessageState({
    required MessageModel messageData,
    required int index,
    required ChatSpaceProvider helperProvider,
    bool? isMessageSelected,
    bool? isReply,
    bool? isForwarded,
    bool? isStar,
    bool? isSeen,
  }) {
    messageData.isForwarded = isForwarded ?? messageData.isForwarded;
    messageData.isReply = isReply ?? messageData.isReply;
    messageData.isSelected = isMessageSelected ?? messageData.isSelected;
    messageData.isStar = isStar ?? messageData.isStar;
    messageData.seen = isSeen ?? messageData.seen;

    int indexOf = helperProvider.messageStatesList.indexOf(messageData);
    // debugPrint(indexOf.toString()+"inside update");
    helperProvider.messageStatesList[indexOf] = messageData;
    if (messageData.isSelected) {
      helperProvider.addSelectedMessages(selectedMessage: messageData);
    }
    if (!messageData.isSelected &&
        helperProvider._selectedMessages.contains(messageData)) {
      helperProvider.removeDeselectedMessages(deselectedMessage: messageData);
    }

    notifyListeners();
  }

  // MessageModel _messageData = MessageModel();
  // MessageModel get currentMessageData => _messageData;
  // void setCurrentMessageData({required MessageModel messageData}) {
  //   _messageData = messageData;
  //   notifyListeners();
  // }

  ChatSpaceModel _chatSpaceData = ChatSpaceModel();
  ChatSpaceModel get chatSpaceData => _chatSpaceData;
  void setChatSpaceData({required ChatSpaceModel chatSpaceData}) {
    _chatSpaceData = chatSpaceData;
    notifyListeners();
  }

  bool _isReplyMessage = true;
  bool get isReplyMessage => _isReplyMessage;
  void setIsReplyMessageStatus({required bool status}) {
    _isReplyMessage = status;
    notifyListeners();
  }

  bool _isLongPressEnable = false;
  bool get isLongPressEnable => _isLongPressEnable;
  void setIsLongPressEnableStatus({required bool status}) {
    _isLongPressEnable = status;
    notifyListeners();
  }

  List<MessageModel> _selectedMessages = [];
  List<MessageModel> get getSelectedMessages => _selectedMessages;
  void removeAllSelectedMessages() {
    _selectedMessages = [];
  }
  void addSelectedMessages({required MessageModel selectedMessage}) {
    _selectedMessages.add(selectedMessage);
    notifyListeners();
  }

  void removeDeselectedMessages({required MessageModel deselectedMessage}) {
    _selectedMessages.remove(deselectedMessage);
    notifyListeners();
  }

  // bool _isMessageSelected = false;
  // bool get isMessageSelected => _isMessageSelected;
  // void setIsMessageSelectedStatus({required bool status}) {
  //   _isMessageSelected = status;
  //   notifyListeners();
  // }

  // MessageModel updateMessageStateHelper({
  //   required MessageModel messageData,
  //   bool? isMessageSelected,
  //   bool? isReply,
  //   bool? isForwarded,
  //   bool? isStar,
  //   bool? isSeen,
  // }) {
  //   messageData.isSelected = isMessageSelected ?? messageData.isSelected;
  //   messageData.isReply = isReply ?? messageData.isReply;
  //   messageData.isForwarded = isForwarded ?? messageData.isForwarded;
  //   messageData.isStar = isStar ?? messageData.isStar;
  //   messageData.seen = isSeen ?? messageData.seen;

  //   return messageData;
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessagesStream({
    required String chatSpaceId,
  }) {
    return FirebaseHelper.fetchMessages(chatSpaceId: chatSpaceId);
  }

  Future<void> sendMessage({
    required messageController,
    required String senderId,
    required ChatSpaceModel chatSpaceData,
    required BuildContext context,
  }) async {
    String inputMessage = messageController.text.trim();

    if (inputMessage.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageId: Utils.uuid.v1(),
        senderId: senderId,
        text: inputMessage,
        createdOn: DateTime.now(),
      );
      await FirebaseFirestore.instance
          .collection("chatspace")
          .doc(chatSpaceData.chatSpaceId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(
            newMessage.toMap(),
          );
      messageController.clear();
      chatSpaceData.lastMessage = inputMessage;
      chatSpaceData.lastMessageTimeStamp = DateTime.now();
      FirebaseFirestore.instance
          .collection("chatspace")
          .doc(chatSpaceData.chatSpaceId)
          .set(chatSpaceData.toMap());
    }
  }
}

import 'package:chat_app/model/chatspace_model.dart';
import 'package:chat_app/services/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/message_model.dart';
import '../../utils/utils.dart';
import '../user_provider.dart';

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

  bool _isReplyMessage = false;
  bool get isReplyMessage => _isReplyMessage;
  void setIsReplyMessageStatus({required bool status}) {
    _isReplyMessage = status;
    notifyListeners();
  }

  // String _repliedToName = "";
  // String get repliedToName => _repliedToName;
  // void setReplidToName({required String name}) {
  //   _repliedToName = name;
  //   notifyListeners();
  // }

  MessageModel _replyMessageData = MessageModel();
  MessageModel get getReplyMessageData => _replyMessageData;
  void setReplyMessageData({required MessageModel replyMessage}) {
    _replyMessageData = replyMessage;
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
    notifyListeners();
  }

  void addSelectedMessages({required MessageModel selectedMessage}) {
    _selectedMessages.add(selectedMessage);
    notifyListeners();
  }

  void addAllSelectedMessages({required List<MessageModel> allMessages}) {
    _selectedMessages.addAll(allMessages);
    notifyListeners();
  }

  void removeDeselectedMessages({required MessageModel deselectedMessage}) {
    _selectedMessages.remove(deselectedMessage);
    notifyListeners();
  }

  void deSelectMessages({
    required int slectedMessagesLength,
    required ChatSpaceProvider value,
  }) {
    for (int i = 0; i < slectedMessagesLength; i++) {
      // debugPrint("index : $i");
      value.updateMessageState(
        messageData: value.getSelectedMessages[0],
        index: i,
        helperProvider: value,
        isMessageSelected: false,
      );
      debugPrint(value.getSelectedMessages.length.toString());
    }
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

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessagesStream(
      {required String chatSpaceId, required BuildContext context}) {
    return FirebaseHelper.fetchMessages(
      chatSpaceId: chatSpaceId,
      context: context,
    );
  }

  Future<void> updateMessageDataOnFirestore({
    required MessageModel messageData,
    required String userId,
    bool? deleteForMe,
    bool? isReply,
  }) async {
    if (deleteForMe != null) {
      deleteForMe = !deleteForMe;
    }
    messageData.deleteForMeCheck?[userId] = deleteForMe ?? true;
    messageData.isReply = isReply ?? messageData.isReply;

    await FirebaseFirestore.instance
        .collection("chatspace")
        .doc(chatSpaceData.chatSpaceId)
        .collection("messages")
        .doc(messageData.messageId)
        .set(
          messageData.toMap(),
        );
  }

  Future<void> deleteDataFromFireStore({
    required MessageModel messageData,
  }) async {
    await FirebaseFirestore.instance
        .collection("chatspace")
        .doc(chatSpaceData.chatSpaceId)
        .collection("messages")
        .doc(messageData.messageId)
        .delete();
  }

  Future<void> forwarMessages({
    required ChatSpaceModel chatSpaceData,
    required List<MessageModel> forwardMessages,
    required String userId,
    required String targetUserId,
  }) async {
    String lastMessage = "";
    for (MessageModel forwardedMessageData in forwardMessages) {
      forwardedMessageData.createdOn = DateTime.now();
      forwardedMessageData.messageId = Utils.uuid.v1();
      forwardedMessageData.senderId = userId;
      forwardedMessageData.deleteForMeCheck = {
        userId: true,
        targetUserId: true,
      };
      forwardedMessageData.isReply = false;
      forwardedMessageData.isForwarded = true;

      lastMessage = forwardedMessageData.text!;

      await FirebaseFirestore.instance
          .collection("chatspace")
          .doc(chatSpaceData.chatSpaceId)
          .collection("messages")
          .doc(forwardedMessageData.messageId)
          .set(
            forwardedMessageData.toMap(),
          );
    }
    chatSpaceData.lastMessage = lastMessage;
    chatSpaceData.lastMessageTimeStamp = DateTime.now();
    chatSpaceData.unseenCounter![targetUserId] =
        chatSpaceData.unseenCounter![targetUserId] + 1;

    FirebaseFirestore.instance
        .collection("chatspace")
        .doc(chatSpaceData.chatSpaceId)
        .set(chatSpaceData.toMap());
  }

  Future<void> sendMessage({
    required messageController,
    required String userId,
    required String targetUserId,
    required ChatSpaceModel chatSpaceData,
    required BuildContext context,
    bool? isReplied,
  }) async {
    String inputMessage = messageController.text.trim();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (inputMessage.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageId: Utils.uuid.v1(),
        senderId: userId,
        text: inputMessage,
        createdOn: DateTime.now(),
        seen: (userProvider.targetuserData.activeStatus!),
        deleteForMeCheck: {
          userId: true,
          targetUserId: true,
        },
        isReply: isReplied ?? false,
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
      chatSpaceData.lastMessage = '- $inputMessage';
      chatSpaceData.lastMessageTimeStamp = DateTime.now();
      // debugPrint(
      //     (chatSpaceData.unseenCounter![targetUserId]).runtimeType.toString());
      chatSpaceData.unseenCounter![targetUserId] =
          chatSpaceData.unseenCounter![targetUserId] + 1;
      FirebaseFirestore.instance
          .collection("chatspace")
          .doc(chatSpaceData.chatSpaceId)
          .set(chatSpaceData.toMap());
    }
  }

  resetUnseenCount({
    required UserProvider userProvider,
    required ChatSpaceProvider chatSpaceProvider,
  }) {
    chatSpaceProvider
        .chatSpaceData.unseenCounter![userProvider.userData.userId!] = 0;

    FirebaseFirestore.instance
        .collection("chatspace")
        .doc(chatSpaceProvider.chatSpaceData.chatSpaceId)
        .set(chatSpaceProvider.chatSpaceData.toMap());
  }

  listenToUnseenCount({
    required ChatSpaceProvider chatSpaceProvider,
    required String targetUser,
  }) {
    FirebaseFirestore.instance
        .collection("chatspace")
        .doc(chatSpaceProvider.chatSpaceData.chatSpaceId)
        .snapshots()
        .listen((event) {
      ChatSpaceModel chatSpaceData = ChatSpaceModel.fromMap(event.data()!);
      chatSpaceProvider.chatSpaceData.unseenCounter![targetUser] =
          chatSpaceData.unseenCounter![targetUser];
      notifyListeners();
    });
  }
}

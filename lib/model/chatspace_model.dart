class ChatSpaceModel {
  String? chatSpaceId;
  Map<String, dynamic>? participants;
  Map<String, dynamic>? unseenCounter;
  Map<String, dynamic>? unseenMessagesList;
  String? lastMessage;
  DateTime? lastMessageTimeStamp;
  Map<String, dynamic>? whichChatSpaceUserActive;

  ChatSpaceModel({
    this.chatSpaceId,
    this.participants,
    this.lastMessage,
    this.lastMessageTimeStamp,
    this.unseenCounter,
    this.unseenMessagesList,
    this.whichChatSpaceUserActive,
  });

  ChatSpaceModel.fromMap(Map<String, dynamic> map) {
    chatSpaceId = map["chatSpaceId"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    lastMessageTimeStamp = map["lastMessageTimeStamp"]?.toDate();
    unseenCounter = map["unseenCounter"];
    unseenMessagesList = map["unseenMessagesList"];
    whichChatSpaceUserActive = map["whichChatSpaceUserActive"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatSpaceId": chatSpaceId,
      "participants": participants,
      "lastMessage": lastMessage,
      "lastMessageTimeStamp": lastMessageTimeStamp,
      "unseenCounter": unseenCounter,
      "unseenMessagesList": unseenMessagesList,
      "whichChatSpaceUserActive":whichChatSpaceUserActive,
    };
  }
}

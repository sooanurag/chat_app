class ChatSpaceModel {
  String? chatSpaceId;
  Map<String, dynamic>? participants;
  Map<String, dynamic>? unseenCounter;
  String? lastMessage;
  DateTime? lastMessageTimeStamp;

  ChatSpaceModel({
    this.chatSpaceId,
    this.participants,
    this.lastMessage,
    this.lastMessageTimeStamp,
    this.unseenCounter
  });

  ChatSpaceModel.fromMap(Map<String, dynamic> map) {
    chatSpaceId = map["chatSpaceId"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    lastMessageTimeStamp = map["lastMessageTimeStamp"]?.toDate();
    unseenCounter = map["unseenCounter"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatSpaceId": chatSpaceId,
      "participants": participants,
      "lastMessage": lastMessage,
      "lastMessageTimeStamp": lastMessageTimeStamp,
      "unseenCounter":unseenCounter,
    };
  }
}

class ChatSpaceModel {
  String? chatSpaceId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? lastMessageTimeStamp;

  ChatSpaceModel(
      {this.chatSpaceId,
      this.participants,
      this.lastMessage,
      this.lastMessageTimeStamp});

  ChatSpaceModel.fromMap(Map<String, dynamic> map) {
    chatSpaceId = map["chatSpaceId"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    lastMessageTimeStamp = map["lastMessageTimeStamp"]?.toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatSpaceId": chatSpaceId,
      "participants": participants,
      "lastMessage": lastMessage,
      "lastMessageTimeStamp":lastMessageTimeStamp,
    };
  }
}

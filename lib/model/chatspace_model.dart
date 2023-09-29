class ChatSpaceModel {
  String? chatroomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? lastMessageTimeStamp;

  ChatSpaceModel(
      {this.chatroomId,
      this.participants,
      this.lastMessage,
      this.lastMessageTimeStamp});

  ChatSpaceModel.fromMap(Map<String, dynamic> map) {
    chatroomId = map["chatroomId"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    lastMessageTimeStamp = map["lastMessageTimeStamp"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomId": chatroomId,
      "participants": participants,
      "lastMessage": lastMessage,
      "lastMessageTimeStamp":lastMessageTimeStamp,
    };
  }
}

class MessageModel {
  String? messageId;
  String? senderId;
  String? text;
  bool seen = false;
  DateTime? createdOn;
  bool isReply = false;
  bool isForwarded = false;
  bool isSelected = false;
  bool isStar = false;

  MessageModel({
    this.senderId,
    this.text,
    this.seen = false,
    this.createdOn,
    this.messageId,
    this.isReply = false,
    this.isForwarded = false,
    this.isSelected = false,
    this.isStar = false,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    senderId = map["senderId"];
    messageId = map["messageId"];
    text = map["text"];
    seen = map["seen"] ;
    createdOn = map["createdOn"].toDate();
    isReply = map["isReply"];
    isForwarded = map["isForwarded"];
    isStar = map["isStar"];
  }

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "messageId": messageId,
      "text": text,
      "seen": seen,
      "createdOn": createdOn,
      "isReply": isReply,
      "isForwarded": isForwarded,
      "isStar": isStar,
    };
  }
}

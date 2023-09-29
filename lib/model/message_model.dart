class MessageModel {
  String? messageId;
  String? senderId;
  String? text;
  bool? seen;
  DateTime? createdOn;
  bool? isReply;
  bool? isForwarded;
  bool? isSelected;
  bool? isStar;

  MessageModel({
    this.senderId,
    this.text,
    this.seen,
    this.createdOn,
    this.messageId,
    this.isReply,
    this.isForwarded,
    this.isSelected,
    this.isStar,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    senderId = map["senderId"];
    messageId = map["messageId"];
    text = map["text"];
    seen = map["seen"];
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
      "isReply":isReply,
      "isForwarded":isForwarded,
      "isStar":isStar,
    };
  }
}

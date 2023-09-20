class MessageModel {
  String? senderID;
  String? receiverID;
  String? dateTime;
  String? messageImage;
  String? text;

  // constructor
  MessageModel({
    this.senderID,
    this.receiverID,
    this.messageImage,
    this.dateTime,
    this.text,
  });
  // named constructor
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    messageImage = json['messageImage'];
    dateTime = json['dateTime'];
    text = json['text'];
  }
  Map<String, dynamic>? toMap() {
    return {
      "senderID": senderID,
      "receiverID": receiverID,
      "messageImage": messageImage,
      "dateTime": dateTime,
      "text": text,
    };
  }
}

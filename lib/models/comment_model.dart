class CommentModel {
  String? profileImage;
  String? name;
  String? uId;
  String? text;
  String? date;
  String? commentID;
  String? commentImage;

  CommentModel(
      {this.name,
      this.text,
      this.profileImage,
      this.commentImage,
      this.date,
      this.uId,
      this.commentID});
  // named constructor
  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    commentImage = json['commentImage'];
    date = json['date'];
    text = json['text'];
    commentID = json['commentID'];
    profileImage = json['profileImage'];
  }
  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "commentImage": commentImage,
      "date": date,
      "text": text,
      "commentID": commentID,
      "profileImage": profileImage,
      "uId": uId,
    };
  }
}

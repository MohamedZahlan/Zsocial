class PostModel {
  String? name;
  String? image;
  String? uId;
  String? postImage;
  String? dateTime;
  String? text;

  // constructor
  PostModel({
    this.name,
    this.postImage,
    this.dateTime,
    this.image,
    this.uId,
    this.text,
  });
  // named constructor
  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];
    text = json['text'];
    image = json['image'];
  }
  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "postImage": postImage,
      "dateTime": dateTime,
      "text": text,
      "image": image,
      "uId": uId,
    };
  }
}

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  String? work;
  //String? gender;
  String? education;
  String? current_city;
  String? relationship;
  String? facebook;
  String? instagram;
  String? linkedIn;
  String? whatsapp;
  String? uId;
  bool? isEmailVerified;

  // constructor
  UserModel({
    this.name,
    this.email,
    this.phone,
    this.image,
    this.cover,
    //this.gender,
    this.bio,
    this.uId,
    this.work,
    this.facebook,
    this.instagram,
    this.linkedIn,
    this.whatsapp,
    this.current_city,
    this.education,
    this.relationship,
    this.isEmailVerified,
  });
  // named constructor
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    linkedIn = json['linkedIn'];
    whatsapp = json['whatsapp'];
    phone = json['phone'];
    //gender = json['gender'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    current_city = json['current_city'];
    education = json['education'];
    work = json['work'];
    relationship = json['relationship'];
    email = json['email'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "email": email,
      //"gender": gender,
      "facebook": facebook,
      "instagram": instagram,
      "linkedIn": linkedIn,
      "whatsapp": whatsapp,
      "phone": phone,
      "image": image,
      "cover": cover,
      "bio": bio,
      "current_city": current_city,
      "education": education,
      "work": work,
      "relationship": relationship,
      "uId": uId,
      "isEmailVerified": isEmailVerified,
    };
  }
}

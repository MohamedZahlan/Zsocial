import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/comment_model.dart';
import '../../../modules/notifications/notifications_screen.dart';
import '../../../modules/users/users_screen.dart';
import '../../../shared/shared_components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  // this method for get data form firebase
  Future<void> getUserData() async {
    emit(SocialLoadingUserState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  //this method for update data
  void updateUserData({
    String? name,
    String? email,
    String? bio,
    String? phone,
    String? image,
    String? cover,
    String? currentCity,
    String? education,
    String? relationship,
    String? facebook,
    String? instagram,
    String? linkedIn,
    String? whatsapp,
    String? work,
  }) {
    emit(SocialUpdateUserLoadingState());
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      facebook: facebook,
      instagram: instagram,
      linkedIn: linkedIn,
      whatsapp: whatsapp,
      work: work,
      isEmailVerified: userModel!.isEmailVerified,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      uId: userModel!.uId,
      bio: bio,
      current_city: currentCity,
      education: education,
      relationship: relationship,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .update(model.toMap()!)
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState(error.toString()));
    });
  }

  // this method for update images
  // void updateUserImages(
  //   String name,
  //   String email,
  //   String bio,
  //   String phone,
  //   String current_city,
  //   String education,
  //   String relationship,
  //   String facebook,
  //   String instagram,
  //   String linkedIn,
  //   String whatsapp,
  //   String work,
  // ) {
  //   emit(SocialUpdateUserLoadingState());
  //   if (coverImage != null) {
  //     uploadCoverImage();
  //   } else if (profileImage != null) {
  //     uploadProfileImage();
  //   } else {}
  // }

  // this method for curved bottom nav
  final iconData = const [
    FaIcon(
      FontAwesomeIcons.house,
      size: 22,
    ),
    FaIcon(
      FontAwesomeIcons.facebookMessenger,
      size: 22,
    ),
    FaIcon(
      FontAwesomeIcons.users,
      size: 22,
    ),
    FaIcon(
      FontAwesomeIcons.solidBell,
      size: 22,
    ),
    FaIcon(
      FontAwesomeIcons.list,
      size: 22,
    ),
  ];

  // this method for display screens when switch bottom nav
  List<Widget> screens = const [
    HomeScreen(),
    ChatsScreen(),
    UsersScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  // this method for change appbar title when switch bottom nav
  List<String> titles = [
    'News Feed',
    'Chats',
    'Find friends',
    "Notifications",
    "Menu"
  ];
  int currentIndex = 0;

  // this method used for bottom nav to navigate to other screen
  void changeBottomNav(int index) {
    if (index == 1) {
      getUsers();
    }
    currentIndex = index;
    emit(SocialChangeBottomNavState());
  }

  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  // this method used for choose profile image
  Future getProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      //profileImage. = userModel!.image;
      emit(SocialProfileImagePickedSuccessState());
    } else {
      debugPrint('No image selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  // this method used to upload profile image to fireStorage
  void uploadProfileImage({
    String? name,
    String? email,
    String? bio,
    String? phone,
    String? image,
    String? cover,
    String? currentCity,
    String? education,
    String? relationship,
    String? facebook,
    String? instagram,
    String? linkedIn,
    String? whatsapp,
    String? work,
  }) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(
          name: name,
          email: email,
          phone: phone,
          facebook: facebook,
          instagram: instagram,
          linkedIn: linkedIn,
          whatsapp: whatsapp,
          work: work,
          image: value,
          cover: cover ?? userModel!.cover,
          bio: bio,
          currentCity: currentCity,
          education: education,
          relationship: relationship,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  File? coverImage;

  // this method used for choose cover image
  Future getCoverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      //profileImage. = userModel!.image;
      emit(SocialCoverImagePickedSuccessState());
    } else {
      debugPrint('No image selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  // this method used to upload cover image to fireStorage
  void uploadCoverImage({
    String? name,
    String? email,
    String? bio,
    String? phone,
    String? image,
    String? cover,
    String? currentCity,
    String? education,
    String? relationship,
    String? facebook,
    String? instagram,
    String? linkedIn,
    String? whatsapp,
    String? work,
  }) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(
          name: name,
          email: email,
          phone: phone,
          facebook: facebook,
          instagram: instagram,
          linkedIn: linkedIn,
          whatsapp: whatsapp,
          work: work,
          image: cover ?? userModel!.image,
          cover: value,
          bio: bio,
          currentCity: currentCity,
          education: education,
          relationship: relationship,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  File? postImage;

  // this method used for get post image image
  Future getPostImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      //profileImage. = userModel!.image;
      emit(SocialPostImagePickedSuccessState());
    } else {
      debugPrint('No image selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  // this method used to select image from gallery and upload Post image to fireStorage
  void createPostWithImage({
    required String text,
    required String dateTime,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState(error));
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error));
    });
  }

  //this method for create post
  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap()!)
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  // this method used for remove image from post
  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  // ------------this method used to get posts data------------
  List<PostModel> postModel = [];
  List<String> comments = [];
  List<String> postID = [];
  List<int> likes = [];

  Future<void> getPostsData() async {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          postModel.add(PostModel.fromJson(element.data()));
          postID.add(element.id);
          likes.add(value.docs.length);
          //if (element.data()['uId'] != userModel!.uId) {}
        }).catchError((error) {});
      }
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  // List<String> postLikesUID = [];
  //
  // Future<void> getPostLikes(String? postID) async {
  //   await FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postID!)
  //       .get()
  //       .then((value) {
  //     postLikesUID = List<String>.from(value.data()!['postLikes']);
  //     print('this post likes are : $postLikesUID');
  //   });
  // }

  // ------------this method used to like posts------------
  void likePost(String postID) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  File? commentImage;

  // ------------this method used for choose cover image------------
  Future getCommentImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      //profileImage. = userModel!.image;
      emit(SocialCommentImagePickedSuccessState());
    } else {
      debugPrint('No image selected');
      emit(SocialCommentImagePickedErrorState());
    }
  }

  // ------------this method used for choose cover image camera------------
  Future getCommentImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      //profileImage. = userModel!.image;
      emit(SocialCommentImagePickedSuccessState());
    } else {
      debugPrint('No image selected');
      emit(SocialCommentImagePickedErrorState());
    }
  }

  // ------------this method used to select image from gallery and upload comment image to fireStorage------------
  void createCommentWithImage({
    required String text,
    required String date,
  }) {
    emit(SocialCommentPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('comments/${Uri.file(commentImage!.path).pathSegments.last}')
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        createComment(
          text: text,
          date: date,
          commentImage: value,
        );
      }).catchError((error) {
        emit(SocialCommentPostErrorState(error));
      });
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error));
    });
  }

  // ------------this method for create comment------------
  void createComment({
    required String text,
    required String date,
    String? commentImage,
  }) {
    emit(SocialCommentPostLoadingState());
    CommentModel commentModel = CommentModel(
      text: text,
      name: userModel!.name,
      date: date,
      profileImage: userModel!.image,
      commentImage: commentImage,
      uId: userModel!.uId,
      commentID: null,
    );
    String commentID = '';
    FirebaseFirestore.instance
        .collection('comments')
        .add(commentModel.toMap()!)
        .then((value) {
      commentID = value.id;
      FirebaseFirestore.instance
          .collection('comments')
          .doc(value.id)
          .update({'commentID': value.id}).then((value) {
        commentModel.commentID = commentID;
        allComments.add(commentModel);
      });
      getComments();
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

  // ------------this method for Get Comments------------

  List<CommentModel> allComments = [];

  void getComments() {
    emit(SocialGetCommentsLoadingState());
    allComments.clear();
    FirebaseFirestore.instance.collection('comments').get().then((value) {
      for (var element in value.docs) {
        allComments.add(CommentModel.fromJson(element.data()));
      }
      emit(SocialGetCommentsSuccessState());
    }).catchError((error) {
      emit(SocialGetCommentsErrorState(error.toString()));
    });
  }

  // ------------this method used to get all users--------------
  List<UserModel> users = [];

  void getUsers() {
    emit(SocialLoadingAllUsersState());
    // users = []; ده حل علشان ميجبش نفس اليوزر اكتر من مره بس ده مش افضل حاجه
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != userModel!.uId) {
            users.add(UserModel.fromJson(element.data()));
          }
        }
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }

  // ------------- this methods for Send Message -----------------

  void sendMessage({
    required String receiverID,
    required String dateTime,
    required String text,
    String? messageImage,
  }) {
    MessageModel messageModel = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverID: receiverID,
      senderID: userModel!.uId,
      messageImage: messageImage ?? '',
    );
    // ----------------- My Messages ----------------------
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .add(messageModel.toMap()!)
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });

    // ----------------- Receiver Messages ----------------------
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap()!)
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });
  }

// ------------- this methods for Send Message -----------------

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverID,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }

  File? messageImage;

  // this method used for get post image image
  Future getMessageImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      //profileImage. = userModel!.image;
      emit(SocialPostImagePickedSuccessState());
    } else {
      debugPrint('No image selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  // this method used to select image from gallery and upload Post image to fireStorage
  void sendMessageWithImage({
    required String receiverID,
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chatImages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        //messageImage = null;
        sendMessage(
            receiverID: receiverID,
            messageImage: value,
            dateTime: dateTime,
            text: text);
      }).catchError((error) {
        emit(SocialSendMessageErrorState(error));
      });
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error));
    });
  }
}

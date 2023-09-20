import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/network/shared.styles/colors.dart';
import 'package:social_app/shared/shared_components/components.dart';

import '../../layout/social_app/cubit/states.dart';

class ChatDetailScreen extends StatelessWidget {
  ChatDetailScreen({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  final messageController = TextEditingController();
  final dateTime = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context)
            .getMessages(receiverID: userModel.uId.toString());
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialCubit cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    // this method for profile photo
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider("${userModel.image}"),
                      radius: 20.0,
                    ),
                    // this method for space between image and username
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 30,
                    ),
                    // this method for Username and date of post
                    Text(
                      "${userModel.name}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.video_call)),
                ],
              ),
              body: ConditionalBuilder(
                condition: cubit.messages.isNotEmpty,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];
                            if (cubit.userModel!.uId == message.senderID) {
                              return buildMyMessages(context, message, index);
                            }
                            return buildMessagesItem(context, message, index);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),

                      // this method for TextFormField and button to send message
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: myDefaultColor,
                            width: 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: myDefaultColor,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  cubit.getMessageImage();
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth(context) / 80,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: messageController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write message here...',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: myDefaultColor,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (cubit.messageImage == null) {
                                    cubit.sendMessage(
                                      receiverID: userModel.uId.toString(),
                                      dateTime: dateTime,
                                      text: messageController.text,
                                    );
                                  } else {
                                    cubit.sendMessageWithImage(
                                      receiverID: userModel.uId.toString(),
                                      dateTime: dateTime,
                                      text: messageController.text,
                                    );
                                  }
                                  messageController.clear();
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  // ------------------ Receiver Messages Item ------------------

  Widget buildMessagesItem(context, MessageModel model, index) {
    var message = SocialCubit.get(context).messages[index];
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
            ),
            child: Text(
              '${model.text}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          if (SocialCubit.get(context).messageImage != null &&
              SocialCubit.get(context).userModel!.uId != message.receiverID)
            Container(
              height: screenHeight(context) / 5,
              width: screenWidth(context) / 1,
              margin: const EdgeInsets.only(right: 150, top: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    SocialCubit.get(context).messageImage!,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                ),
              ),
            ),
        ],
      ),
    );
  }

// ------------------ My Messages Item ------------------

  Widget buildMyMessages(context, MessageModel model, index) {
    var message = SocialCubit.get(context).messages[index];
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: myDefaultColor.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
            ),
            child: Text(
              '${model.text}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          if (SocialCubit.get(context).messageImage != null &&
              SocialCubit.get(context).userModel!.uId == message.senderID)
            Container(
              height: screenHeight(context) / 5,
              width: screenWidth(context) / 1,
              margin: const EdgeInsets.only(left: 150, top: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    SocialCubit.get(context).messageImage!,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

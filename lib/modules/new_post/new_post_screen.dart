import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/layout/social_app/social_app.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../../shared/shared_components/components.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);

  final textController = TextEditingController();
  final now = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text(
              "New Post",
            ),
            actions: [
              defaultTextButton(
                function: () {
                  if (cubit.postImage == null) {
                    cubit.createPost(
                      text: textController.text,
                      dateTime: now,
                    );
                    showToast(msg: "Uploading", state: ToastStates.SUCCESS);
                    Navigator.pop(context);
                  } else {
                    cubit.createPostWithImage(
                      text: textController.text,
                      dateTime: now,
                    );
                    showToast(msg: "Uploading", state: ToastStates.SUCCESS);
                    cubit.getPostsData().then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
                text: "POST",
                context: context,
                color: Colors.white,
                fontSize: 16.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  SizedBox(
                    height: screenHeight(context) / 70,
                  ),
                // this method for profile details
                Row(
                  children: [
                    // this method for profile image
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider("${userModel!.image}"),
                      radius: 30,
                    ),
                    // for space
                    SizedBox(
                      width: screenWidth(context) / 20,
                    ),
                    // this method for username and select who can see post
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${userModel.name}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(
                          height: screenHeight(context) / 130,
                        ),
                        Text(
                          "Public",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                // this method for space between them
                SizedBox(
                  height: screenHeight(context) / 40,
                ),
                // this method for default text
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "What is on your mind, ${userModel.name}?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // this method for post image
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      FullScreenWidget(
                        child: Center(
                          child: Hero(
                            tag: 'post image',
                            child: Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                bottom: 35,
                                top: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                    cubit.postImage!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // this method for edit cover button
                      CircleAvatar(
                        radius: 20,
                        child: IconButton(
                            onPressed: () {
                              SocialCubit.get(context).removePostImage();
                            },
                            icon: const Icon(
                              Icons.close,
                            )),
                      ),
                    ],
                  ),
                // if (cubit.postImage != null)
                //   SizedBox(
                //     height: screenHeight(context) / 40,
                //   ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library_outlined,
                                color: myDefaultColor),
                            SizedBox(
                              width: screenWidth(context) / 45,
                            ),
                            Text(
                              "Add Photos",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 14.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context) / 45,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tag, color: myDefaultColor),
                            SizedBox(
                              width: screenWidth(context) / 45,
                            ),
                            Text(
                              "Tags",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 14.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

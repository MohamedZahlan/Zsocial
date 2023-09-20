import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/shared_components/components.dart';

import '../../models/user_model.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        var users = cubit.users;
        return ConditionalBuilder(
          condition: users.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(context, users[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: users.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  // this method for user details
  Widget buildChatItem(context, UserModel userModel) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailScreen(userModel: userModel));
        },
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // this method for profile photo
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider("${userModel.image}"),
              radius: 25,
            ),
            // this method for space between image and username
            SizedBox(
              width: MediaQuery.of(context).size.width / 30,
            ),
            // this method for Username and date of post
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // this method for username
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // this method for name
                    Text(
                      "${userModel.name}",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    // this method for space between profile image and icon verify
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 60,
                    ),
                    if (!FirebaseAuth.instance.currentUser!.emailVerified)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 17,
                      ),
                  ],
                ),
                // this method for space between username and date
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 200,
                // ),
                // Text(
                //   "Hello, I'm Mohamed",
                //   style: Theme.of(context).textTheme.subtitle1,
                // ),
              ],
            ),
          ],
        ),
      );
}

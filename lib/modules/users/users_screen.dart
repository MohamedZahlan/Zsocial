import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/network/shared.styles/colors.dart';

import '../../layout/social_app/cubit/cubit.dart';
import '../../layout/social_app/cubit/states.dart';
import '../../models/user_model.dart';
import '../../shared/shared_components/components.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

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
                buildFriendsItem(context, users[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: users.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  // this method for find friends
  Widget buildFriendsItem(context, UserModel userModel) => InkWell(
        onTap: () {},
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
                      width: MediaQuery.of(context).size.width / 75,
                    ),
                    if (!FirebaseAuth.instance.currentUser!.emailVerified)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 17,
                      ),
                    SizedBox(
                      width: screenWidth(context) / 7.5,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => myDefaultColor,
                      )),
                      onPressed: () {},
                      child: Text(
                        "Add friend",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
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

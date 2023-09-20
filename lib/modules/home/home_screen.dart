import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/comment/comments_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../../shared/shared_components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getUserData();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var userModel = SocialCubit.get(context).userModel;
            var postModel = SocialCubit.get(context).postModel;
            SocialCubit cubit = SocialCubit.get(context);

            return ConditionalBuilder(
              condition: userModel != null,
              builder: (context) => LiquidPullToRefresh(
                onRefresh: () => cubit.getPostsData(),
                color: Colors.white,
                borderWidth: screenWidth(context) / 30,
                backgroundColor: myDefaultColor,
                height: screenHeight(context) / 7,
                showChildOpacityTransition: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // this method for Create post UI
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                // this method for user profile image
                                InkWell(
                                  onTap: () {
                                    navigateTo(context, const ProfileScreen());
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        "${userModel!.image}"),
                                    radius: 25,
                                  ),
                                ),
                                // this method for space between image and create post
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 60,
                                ),
                                // this method for TextField used to navigate to create post
                                Expanded(
                                  child: TextField(
                                    onTap: () {
                                      navigateTo(context, NewPostScreen());
                                    },
                                    readOnly: true,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      hintText: "What's on your mind ?",
                                    ),
                                  ),
                                ),
                                // this method for space between create post and add photo
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 30,
                                ),
                                // this method for divider
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  width: 2,
                                  color: Colors.grey.shade300,
                                ),
                                // this method for add photo in the post
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.photo_library_outlined,
                                      color: myDefaultColor,
                                      size: 30,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // this method for display posts
                      ListView.separated(
                        reverse: true,
                        padding: const EdgeInsets.only(bottom: 5),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => buildPostItem(
                          context,
                          userModel,
                          postModel[index],
                          index,
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height / 70,
                        ),
                        itemCount: postModel.length,
                      ),
                    ],
                  ),
                ),
              ),
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }

  // this method for build post UI
  Widget buildPostItem(context, UserModel model, PostModel postModel, index) =>
      Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // this method for user details
              Row(
                children: [
                  // this method for profile photo
                  InkWell(
                    onTap: () {
                      navigateTo(context, const ProfileScreen());
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider("${postModel.image}"),
                      radius: 25,
                    ),
                  ),
                  // this method for space between image and username
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 60,
                  ),
                  // this method for Username and date of post
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // this method for username
                        Row(
                          children: [
                            // this method for name
                            InkWell(
                              onTap: () {
                                navigateTo(context, const ProfileScreen());
                              },
                              child: Text(
                                "${postModel.name}",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            // this method for space between profile image and icon verify
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 60,
                            ),
                            if (FirebaseAuth
                                .instance.currentUser!.emailVerified)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 17,
                              ),
                          ],
                        ),
                        // this method for space between username and date
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 200,
                        ),
                        // this method for date of the post
                        Row(
                          children: [
                            Text(
                              //"Yesterday at 3:50 PM  .",
                              "${postModel.dateTime}",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 60,
                            ),
                            const FaIcon(
                              FontAwesomeIcons.earthAfrica,
                              size: 12,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // this method for space between username and IconButton
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 60,
                  ),
                  // this method for IconButton More
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz_sharp,
                    ),
                  ),
                ],
              ),
              // this method for divider between user details and post
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade200,
              ),
              // this method for post text
              Text(
                "${postModel.text}",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              // this method for space between and post
              SizedBox(
                height: screenHeight(context) / 75,
              ),
              //this method for tags buttons
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 6,
                      ),
                      child: SizedBox(
                        height: screenHeight(context) / 26,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "#software",
                            textAlign: TextAlign.start,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: myDefaultColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 6,
                      ),
                      child: SizedBox(
                        height: screenHeight(context) / 26,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "#flutter",
                            textAlign: TextAlign.start,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: myDefaultColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 6,
                      ),
                      child: SizedBox(
                        height: screenHeight(context) / 26,
                        //width: screenWidth(context) / 6,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "#software_developer",
                            textAlign: TextAlign.start,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: myDefaultColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //this method for display image in the post
              if (postModel.postImage != '')
                FullScreenWidget(
                  child: Hero(
                    tag: 'Hero',
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              "${postModel.postImage}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // this method for space between post and likes & comments
              SizedBox(
                height: MediaQuery.of(context).size.height / 80,
              ),
              // this method for likes & comments
              Row(
                children: [
                  // first row for like icon and number of likes
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 80,
                            ),
                            Text(
                              "${SocialCubit.get(context).likes[index]}",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, CommentsScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.comment,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 80,
                            ),
                            Text(
                              " comments",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // this method for divider between like & comments Icons
              Container(
                margin: const EdgeInsets.all(10.0),
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade200,
              ),
              // this method for add comment or like post or share
              Row(
                children: [
                  // this method for Like button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        SocialCubit.get(context)
                            .likePost(SocialCubit.get(context).postID[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                              size: 22,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 80,
                            ),
                            Text(
                              "Like",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // this method for divider to make space
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: 2,
                    margin: const EdgeInsets.only(
                      right: 12,
                      left: 3,
                    ),
                    color: Colors.grey.shade300,
                  ),
                  // this method for Comment button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, CommentsScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 3.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.comment,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 80,
                            ),
                            Text(
                              "Comment",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // this method for second divider to make space
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    color: Colors.grey.shade300,
                  ),
                  // this method for Share button
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.share,
                              color: Colors.grey,
                              size: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 80,
                            ),
                            Text(
                              "Share",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // this method for space between number of likes & comments and buttons of them
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              // this method for write a comment
              InkWell(
                onTap: () {
                  navigateTo(context, CommentsScreen());
                },
                child: Row(
                  children: [
                    // this method for profile photo
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider("${model.image}"),
                      radius: 18.0,
                    ),
                    // this method for space between image and username
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 60,
                    ),
                    // this method for Username and date of post
                    Expanded(
                      child: Text(
                        "Write a comment",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/shared_components/components.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:social_app/shared/shared_components/constants.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../new_post/new_post_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var userModel = SocialCubit.get(context).userModel;
            var postModel = SocialCubit.get(context).postModel;
            var cubit = SocialCubit.get(context);
            return ConditionalBuilder(
              condition: userModel != null,
              builder: (context) => Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  centerTitle: true,
                  title: Text(
                    "${userModel!.name}",
                    //style: Theme.of(context).textTheme.bodyText2,
                  ),
                  actions: [
                    CircleAvatar(
                      radius: 20,
                      child: IconButton(
                        onPressed: () {
                          navigateTo(context, const SearchScreen());
                        },
                        icon: const Icon(
                          Icons.search_sharp,
                          size: 26,
                          //color: myDefaultColor,
                        ),
                      ),
                    ),
                  ],
                ),
                body: LiquidPullToRefresh(
                  onRefresh: () => cubit.getUserData(),
                  color: Colors.white,
                  borderWidth: screenWidth(context) / 30,
                  backgroundColor: myDefaultColor,
                  height: screenHeight(context) / 7,
                  showChildOpacityTransition: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // this method for username,images,edit profile
                        Card(
                          elevation: 5.0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              // this method for cover and profile image
                              Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  // this method for cover
                                  FullScreenWidget(
                                    child: Center(
                                      child: Hero(
                                        tag: 'cover',
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(bottom: 35),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(5.0),
                                              topLeft: Radius.circular(5.0),
                                            ),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                userModel.cover.toString(),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // this method for profile image
                                  CircleAvatar(
                                    radius: 62.0,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: FullScreenWidget(
                                      child: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          userModel.image.toString(),
                                        ),
                                        radius: 60.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // this method for space between profile images and username
                              SizedBox(
                                height: screenHeight(context) / 70,
                              ),
                              // this method for username
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${userModel.name}",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  // this method for space between profile image and icon verify
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 60,
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
                              // this method for space between username and bio
                              SizedBox(
                                height: screenHeight(context) / 70,
                              ),
                              // this method for bio
                              Text(
                                "${userModel.bio}",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              // this method for space between username && bio and followers && friends method
                              SizedBox(
                                height: screenHeight(context) / 30,
                              ),
                              // this method for followers && friends
                              Row(
                                children: [
                                  // this method for number of followers
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "100k",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        Text(
                                          "Followers",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // this method for number of friends
                                  Expanded(
                                    child: Column(
                                      children: [
                                        // this method for username
                                        Text(
                                          "1k",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        Text(
                                          "Friends",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // this method for number of photos
                                  Expanded(
                                    child: Column(
                                      children: [
                                        // this method for username
                                        Text(
                                          "150",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        Text(
                                          "Photos",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // this method for space between followers && friends method and edit profile button
                              SizedBox(
                                height: screenHeight(context) / 50,
                              ),
                              // this method for edit && add photo button
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Add Photos",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        navigateTo(
                                            context, EditProfileScreen());
                                      },
                                      child: Text(
                                        "Edit Profile",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // this method for Details
                            ],
                          ),
                        ),
                        // this method for spacing
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                        // this method for user details
                        Card(
                          elevation: 5.0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Details"),
                                    const Spacer(),
                                    defaultTextButton(
                                      function: () {
                                        navigateTo(
                                            context, EditProfileScreen());
                                      },
                                      text: "Edit",
                                      fontSize: 16.0,
                                      context: context,
                                    ),
                                  ],
                                ),
                                // this method for spacing
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 60,
                                ),
                                // this method for user study
                                if (userModel.work!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.work,
                                        size: 23,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${userModel.work}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                // this method for spacing
                                if (userModel.work!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                // this method for user study
                                if (userModel.education!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.graduationCap,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${userModel.education}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                // this method for spacing
                                if (userModel.education!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                // this method for current city
                                if (userModel.current_city!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.houseUser,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${userModel.current_city}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                // this method for spacing
                                if (userModel.current_city!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                // this method for relationship
                                if (userModel.relationship!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.heart,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${userModel.relationship}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                // this method for spacing
                                if (userModel.relationship!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                // this method for facebook
                                if (userModel.facebook!.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      facebook(context);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.facebook,
                                          size: 20,
                                          color: myDefaultColor,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${userModel.facebook}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // this method for spacing
                                if (userModel.facebook!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                // this method for linkedIn
                                if (userModel.linkedIn!.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      linkedin(context);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.linkedin,
                                          size: 20,
                                          color: myDefaultColor,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${userModel.linkedIn}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // this method for spacing
                                if (userModel.linkedIn!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                // this method for instagram
                                if (userModel.instagram!.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      instagram(context);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.instagram,
                                          size: 20,
                                          color: Colors.pinkAccent,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${userModel.instagram}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // this method for spacing
                                if (userModel.instagram!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                // this method for whatsapp
                                if (userModel.whatsapp!.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      whatsapp(context);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.whatsapp,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${userModel.whatsapp}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // this method for spacing
                                if (userModel.whatsapp!.isNotEmpty)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // this method for spacing
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 80,
                        ),
                        // this method for Create post UI
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  // this method for user profile image
                                  InkWell(
                                    onTap: () {
                                      navigateTo(
                                          context, const ProfileScreen());
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              "${userModel.image}"),
                                      radius: 25,
                                    ),
                                  ),
                                  // this method for space between image and create post
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 60,
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        hintText: "What's on your mind ?",
                                      ),
                                    ),
                                  ),
                                  // this method for space between create post and add photo
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 30,
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
                        // this method for spacing
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 80,
                        ),
                        // this method for display posts
                        ListView.separated(
                          reverse: true,
                          padding: const EdgeInsets.only(bottom: 5),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPostItem(
                              context, userModel, postModel[index], index),
                          separatorBuilder: (context, index) => SizedBox(
                            height: MediaQuery.of(context).size.height / 70,
                          ),
                          itemCount: postModel.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
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
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider("${postModel.image}"),
                    radius: 25,
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
                            Text(
                              "${postModel.name}",
                              style: Theme.of(context).textTheme.bodyText2,
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
                              Icons.favorite_border,
                              color: Colors.grey,
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
                      onTap: () {},
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
                              "0 comments",
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
                      onTap: () {},
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
                onTap: () {},
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

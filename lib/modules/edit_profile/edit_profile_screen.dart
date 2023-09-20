import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../../shared/shared_components/components.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final bioController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final workController = TextEditingController();
  final educationController = TextEditingController();
  final cityController = TextEditingController();
  final relationshipController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final linkedInController = TextEditingController();
  final whatsappController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialGetUserSuccessState) {
          showToast(msg: 'Updated Successfully', state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel!;
        var cubit = SocialCubit.get(context);
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        usernameController.text = userModel.name!;
        bioController.text = userModel.bio!;
        emailController.text = userModel.email!;
        phoneController.text = userModel.phone!;
        workController.text = userModel.work!;
        educationController.text = userModel.education!;
        cityController.text = userModel.current_city!;
        relationshipController.text = userModel.relationship!;
        facebookController.text = userModel.facebook!;
        instagramController.text = userModel.instagram!;
        linkedInController.text = userModel.linkedIn!;
        whatsappController.text = userModel.whatsapp!;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title: const Text(
              "Edit Profile",
              //style: Theme.of(context).textTheme.subtitle2!.copyWith(),
            ),
            actions: [
              defaultTextButton(
                function: () {
                  if (SocialCubit.get(context).profileImage != null) {
                    SocialCubit.get(context).uploadProfileImage(
                      name: usernameController.text,
                      email: emailController.text,
                      bio: bioController.text,
                      phone: phoneController.text,
                      work: workController.text,
                      whatsapp: whatsappController.text,
                      linkedIn: linkedInController.text,
                      instagram: instagramController.text,
                      facebook: facebookController.text,
                      relationship: relationshipController.text,
                      education: educationController.text,
                      currentCity: cityController.text,
                    );
                  } else if (SocialCubit.get(context).coverImage != null) {
                    SocialCubit.get(context).uploadCoverImage(
                      name: usernameController.text,
                      email: emailController.text,
                      bio: bioController.text,
                      phone: phoneController.text,
                      work: workController.text,
                      whatsapp: whatsappController.text,
                      linkedIn: linkedInController.text,
                      instagram: instagramController.text,
                      facebook: facebookController.text,
                      relationship: relationshipController.text,
                      education: educationController.text,
                      currentCity: cityController.text,
                    );
                  } else {
                    if (_formKey.currentState!.validate()) {
                      cubit.updateUserData(
                        name: usernameController.text,
                        email: emailController.text,
                        bio: bioController.text,
                        phone: phoneController.text,
                        work: workController.text,
                        whatsapp: whatsappController.text,
                        linkedIn: linkedInController.text,
                        instagram: instagramController.text,
                        facebook: facebookController.text,
                        relationship: relationshipController.text,
                        education: educationController.text,
                        currentCity: cityController.text,
                      );
                    }
                  }
                },
                text: "Save",
                context: context,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ],
          ),
          body: userModel.toMap()!.isNotEmpty
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // for update profile details
                          if (state is SocialLoadingUserState)
                            const LinearProgressIndicator(),
                          // for update profile details
                          if (state is SocialLoadingUserState)
                            SizedBox(
                              height: screenHeight(context) / 40,
                            ),
                          // for update profile Images
                          if (state is SocialUpdateUserLoadingState)
                            const LinearProgressIndicator(),
                          if (state is SocialUpdateUserLoadingState)
                            SizedBox(
                              height: screenHeight(context) / 40,
                            ),
                          // this method for edit cover and profile image
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              // this method for edit cover
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  FullScreenWidget(
                                    backgroundColor: Colors.white10,
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
                                              image: coverImage == null
                                                  ? CachedNetworkImageProvider(
                                                      userModel.cover
                                                          .toString(),
                                                    )
                                                  : FileImage(
                                                      coverImage,
                                                    ) as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // this method for edit cover button
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            SocialCubit.get(context)
                                                .getCoverImage();
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              // this method for edit profile image
                              CircleAvatar(
                                radius: 62.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    profileImage == null
                                        ? FullScreenWidget(
                                            backgroundColor: Colors.white10,
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                userModel.image.toString(),
                                              ),
                                              radius: 60.0,
                                            ),
                                          )
                                        : FullScreenWidget(
                                            child: Hero(
                                              tag: 'profile1',
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Image.file(
                                                  profileImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                    // this method for edit profile image button
                                    CircleAvatar(
                                      radius: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            SocialCubit.get(context)
                                                .getProfileImage();
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // this method for space between profile images and username
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          const Text("Personal Details"),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method edit username
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            controller: usernameController,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username must not be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffix: defaultTextButton(
                                function: () {},
                                text: "Save",
                                context: context,
                                fontSize: 12.0,
                                textAlign: TextAlign.end,
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                size: 25,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between edit bio and username
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method edit bio
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            controller: bioController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.read_more_outlined,
                                size: 25,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between edit username and email
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method edit email
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'E-mail must not be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                size: 25,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between edit email and phone
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method edit phone
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone_android_outlined,
                                size: 25,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between TextFormField and text
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          const Text("Works"),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method edit work
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            controller: workController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.work,
                                size: 25,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between TextFormField and text
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          const Text("Education"),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method for space between text and TextFormField
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            controller: educationController,
                            keyboardType: TextInputType.text,
                            maxLines: 2,
                            decoration: InputDecoration(
                              prefixIcon: const FaIcon(
                                FontAwesomeIcons.graduationCap,
                                size: 25,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between TextFormField and text
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          const Text("Current city"),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method for Location city TextFormField
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            textAlign: TextAlign.start,
                            controller: cityController,
                            keyboardType: TextInputType.streetAddress,
                            maxLines: 2,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.location_on,
                                size: 30,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between TextFormField and text
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          const Text("Relationship"),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method for relationship
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            textAlign: TextAlign.start,
                            controller: relationshipController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.favorite_border,
                                size: 30,
                                //color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          const Text("Websites"),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method for facebook link
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            textAlign: TextAlign.start,
                            controller: facebookController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.facebook,
                                size: 30,
                                color: myDefaultColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method for linkedIn link
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            textAlign: TextAlign.start,
                            controller: linkedInController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.linkedin,
                                size: 30,
                                color: myDefaultColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method for instagram link
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            textAlign: TextAlign.start,
                            controller: instagramController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.instagram,
                                size: 30,
                                color: Colors.pinkAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          // this method for space between text and TextFormField
                          SizedBox(
                            height: screenHeight(context) / 60,
                          ),
                          // this method for whatsapp link
                          TextFormField(
                            onTap: () {},
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  work: workController.text,
                                  whatsapp: whatsappController.text,
                                  linkedIn: linkedInController.text,
                                  instagram: instagramController.text,
                                  facebook: facebookController.text,
                                  relationship: relationshipController.text,
                                  education: educationController.text,
                                  currentCity: cityController.text,
                                );
                              }
                            },
                            textAlign: TextAlign.start,
                            controller: whatsappController,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onSaved: (value) {},
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.whatsapp,
                                size: 30,
                                color: Colors.green,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

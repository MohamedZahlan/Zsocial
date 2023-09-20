import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/shared_components/constants.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../../shared/shared_components/components.dart';
import '../profile/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        bool isDark = true;
        return Scaffold(
          body: userModel != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // this method for navigate to user profile
                      InkWell(
                        onTap: () {
                          navigateTo(context, const ProfileScreen());
                        },
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      "${userModel.image}"),
                                  radius: 25,
                                ),
                                SizedBox(
                                  width: screenWidth(context) / 20,
                                ),
                                Text(
                                  "${userModel.name}",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // this method for spacing between user profile and change theme AppMode
                      SizedBox(
                        height: screenHeight(context) / 40,
                      ),
                      // this method to change theme AppMode
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.dark_mode_outlined),
                              SizedBox(
                                width: screenWidth(context) / 20,
                              ),
                              Text(
                                "Dark Mode",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const Spacer(),
                              Switch(
                                value: isDark,
                                activeColor: myDefaultColor,
                                onChanged: (value) {
                                  isDark = !isDark;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: myDefaultColor, //HexColor('#53B175'),
                            borderRadius: BorderRadius.circular(15)),
                        child: MaterialButton(
                          //shape: const StadiumBorder(),
                          onPressed: () {
                            signOut(context);
                          },
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 20,
                              color: HexColor('#FFF9FF'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

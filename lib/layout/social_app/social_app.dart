import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/shared/shared_components/components.dart';

import '../../modules/search/search_screen.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            height: screenHeight(context) / 15,
            index: cubit.currentIndex,
            //color: Colors.black,
            animationDuration: const Duration(
              milliseconds: 500,
            ),
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: cubit.iconData,
          ),
          body: ConditionalBuilder(
            condition:
                FirebaseFirestore.instance.collection('users').doc() != null,
            builder: (context) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    titleSpacing: screenWidth(context) / 23,
                    title: Text(
                      cubit.titles[cubit.currentIndex],
                      // style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25,),
                    ),
                    floating: true,
                    pinned: true,
                    actions: [
                      CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          enableFeedback: true,
                          onPressed: () {
                            navigateTo(context, SearchScreen());
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
                ];
              },
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // this method used for check if account Verified or no and if no display message for user to verify acc
                    if (!FirebaseAuth.instance.currentUser!.emailVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          //borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                            ),
                            Text(
                              "Please verify your email",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            const Spacer(),
                            defaultTextButton(
                              function: () {
                                // this method used for send mail to verify account
                                FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification()
                                    .then((value) {
                                  showToast(
                                      msg: "Check your mail",
                                      state: ToastStates.SUCCESS);
                                }).catchError((error) {
                                  debugPrint(error.toString());
                                });
                              },
                              text: 'SEND',
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: cubit.screens[cubit.currentIndex],
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

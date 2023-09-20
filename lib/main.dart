import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/shared.styles/themes.dart';
import 'package:social_app/shared/shared_components/constants.dart';
import 'layout/social_app/cubit/states.dart';
import 'modules/splash_screen/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  Bloc.observer = MyBlocObserver();
  await Cache_Helper.init();
  uId = Cache_Helper.getData(key: 'uId');

  runApp(const MyApp()
      // DevicePreview(
      //   builder: (BuildContext context) => const MyApp(),
      // ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
        ..getPostsData()
        ..getComments()
        ..getUsers(),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: ThemeMode.light,
            darkTheme: darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

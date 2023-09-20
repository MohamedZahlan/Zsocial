import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';

import '../../layout/social_app/social_app.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../../shared/shared_components/components.dart';
import '../social_login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var uId = Cache_Helper.getData(key: 'uId');
  late Widget startScreen;

  @override
  // For splash screen and select time for splash screen
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (uId != null) {
        startScreen = const SocialLayout();
        SocialCubit.get(context).getPostsData();
        SocialCubit.get(context).getUserData();
      } else {
        startScreen = const SocialLoginScreen();
      }
      navigateToFinish(context, startScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDefaultColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: myDefaultColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: myDefaultColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Center(
        // this text is show in splash screen
        child: Text(
          "Zsocial",
          style: TextStyle(
            color: HexColor('#FFFCFC'),
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

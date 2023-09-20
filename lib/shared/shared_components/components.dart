import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';

import '../network/shared.styles/colors.dart';

double screenWidth(context) {
  return MediaQuery.of(context).size.width;
}

Future getLatAndLong() async {
  return await Geolocator.getCurrentPosition();
}

double screenHeight(context) {
  return MediaQuery.of(context).size.height;
}

void navigateTo(context, screen) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return screen;
        },
      ),
    );

void navigateToFinish(context, screen) =>
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return screen;
    }), (route) => false);

Widget myDivider() => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey[200],
      ),
    );

defaultTextButton(
        {required Function function,
        required String text,
        Color? color,
        TextAlign? textAlign,
        dynamic fontSize,
        required context}) =>
    TextButton(
      onPressed: () {
        function();
      },
      child: Text(
        text,
        textAlign: textAlign,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: color,
              fontSize: fontSize,
            ),
      ),
    );

void showToast({
  required String msg,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        backgroundColor: toastSetColor(state),
        timeInSecForIosWeb: 5,
        fontSize: 14,
        toastLength: Toast.LENGTH_LONG);

enum ToastStates { SUCCESS, ERROR, WARNING }

toastSetColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

enum AnimationEnum {
  idle,
  Hands_up,
  hands_down,
  success,
  fail,
  Look_down_right,
  Look_down_left,
  look_idle
}

Widget defaultButtonBuilder({
  required String text,
  required double fontSize,
  required double doubleWidth,
  required Function function,
  required bool condition,
}) =>
    ConditionalBuilder(
      condition: condition,
      builder: (context) => Container(
        height: 60,
        width: doubleWidth,
        decoration: BoxDecoration(
            color: myDefaultColor, //HexColor('#53B175'),
            borderRadius: BorderRadius.circular(15)),
        child: MaterialButton(
          //shape: const StadiumBorder(),
          onPressed: () {
            function();
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: HexColor('#FFF9FF'),
            ),
          ),
        ),
      ),
      fallback: (context) => const Center(child: CircularProgressIndicator()),
    );

Widget defaultButton({
  required String text,
  required double fontSize,
  required double doubleWidth,
  required double borderRadius,
  required Function function,
}) =>
    Container(
      height: 40,
      width: doubleWidth,
      decoration: BoxDecoration(
        color: myDefaultColor, //HexColor('#53B175'),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: MaterialButton(
        //shape: const StadiumBorder(),
        onPressed: () {
          function();
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: HexColor('#FFF9FF'),
          ),
        ),
      ),
    );

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  //required Function onPressed,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      centerTitle: true,
      title: Text(
        title!,
        //style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: actions,
    );

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  primarySwatch: defaultColorDark,
  //fontFamily: 'Jannah',
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    backgroundColor: Colors.white10,
  )),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: myDefaultColor,
  ),
  cardTheme: const CardTheme(
    color: Colors.black12,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    elevation: 0.0,
    titleSpacing: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        //fontFamily: 'Jannah',
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 19),
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black),
  ),
  hintColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 20,
    backgroundColor: Colors.black12,
    unselectedIconTheme: const IconThemeData(color: Colors.white),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: myDefaultColor,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white10, elevation: 10.0),
  textTheme: TextTheme(
    bodyText1: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    ),
    bodyText2: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    ),
    caption: const TextStyle(
      color: Colors.grey,
    ),
    subtitle1: const TextStyle(
      color: Colors.white, //Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
      height: 1.5,
    ),
    subtitle2: TextStyle(
      color: myDefaultColor, //Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 15.0,
      height: 1.5,
    ),
  ),
  unselectedWidgetColor: Colors.black,
  indicatorColor: myDefaultColor,
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade50, //myDefaultColor,
  primarySwatch: defaultColor,
  indicatorColor: myDefaultColor,
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: myDefaultColor,
  ),
  //fontFamily: 'Jannah',
  cardTheme: const CardTheme(),
  appBarTheme: AppBarTheme(
    color: myDefaultColor,
    elevation: 5.0,
    shadowColor: Colors.white,
    titleSpacing: 0,
    actionsIconTheme: const IconThemeData(
      size: 25,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
        // fontFamily: 'Jannah',
        color: Colors.white, //myDefaultColor,
        fontWeight: FontWeight.bold,
        fontSize: 20.0),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: myDefaultColor, //Colors.white, //Colors.white
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 20,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: myDefaultColor,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: myDefaultColor, //Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    ),
    bodyText2: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    ),
    subtitle1: const TextStyle(
      color: Colors.black, //Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
      height: 1.5,
    ),
    subtitle2: const TextStyle(
      color: Colors.white, //Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 15.0,
      height: 1.5,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
);

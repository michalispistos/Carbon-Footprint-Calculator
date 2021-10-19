import 'package:flutter/material.dart';

class CustomTheme {
  static const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
  static const COLOR_GREY = Color.fromRGBO(141, 141, 141, 1.0);
  static const COLOR_WHITE = Colors.white;

  static ThemeData get lightTheme {
    Map<int, Color> color = {
      50: Color.fromRGBO(253, 236, 166, .1),
      100: Color.fromRGBO(253, 236, 166, .2),
      200: Color.fromRGBO(253, 236, 166, .3),
      300: Color.fromRGBO(253, 236, 166, .4),
      400: Color.fromRGBO(253, 236, 166, .5),
      500: Color.fromRGBO(253, 236, 166, .6),
      600: Color.fromRGBO(253, 236, 166, .7),
      700: Color.fromRGBO(253, 236, 166, .8),
      800: Color.fromRGBO(253, 236, 166, .9),
      900: Color.fromRGBO(253, 236, 166, 1),
    };

    return ThemeData(
        primarySwatch: MaterialColor(0xfffffaca, color),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito Sans',
        textTheme: const TextTheme(
            headline1: TextStyle(
                color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 26),
            headline2: TextStyle(
                color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22),
            headline3: TextStyle(
                color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20),
            headline4: TextStyle(
                color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 16),
            headline5: TextStyle(
                color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14),
            headline6: TextStyle(
                color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12),
            bodyText1: TextStyle(
                color: COLOR_BLACK,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5),
            bodyText2: TextStyle(
                color: COLOR_GREY,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5),
            subtitle1: TextStyle(
                color: COLOR_BLACK, fontSize: 12, fontWeight: FontWeight.w400),
            subtitle2: TextStyle(
                color: COLOR_GREY, fontSize: 12, fontWeight: FontWeight.w400)),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xfffffaca)))),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xfffffaca))),
        ),
        tabBarTheme: TabBarTheme(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: CustomTheme.COLOR_BLACK.withAlpha(80),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10), labelColor: Colors.white));
  }
}

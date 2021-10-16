import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        // primaryColor: Colors.purple,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito Sans', //3
        textButtonTheme: TextButtonThemeData( // 4
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xfffffaca)))),
              foregroundColor:
              MaterialStateProperty.all<Color>(Colors.black),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xfffffaca))),
        )
    );
  }
}
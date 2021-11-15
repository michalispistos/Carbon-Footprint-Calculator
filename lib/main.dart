import 'package:carbon_footprint_calculator/screens/check_item.dart';
import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;

import 'screens/login.dart';

void main() => {
      WidgetsFlutterBinding.ensureInitialized(),
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]),
      runApp(MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Carbon Footprint Calculator",
          theme: CustomTheme.lightTheme,
          home: const LoginPage(signOut: false)))
    };

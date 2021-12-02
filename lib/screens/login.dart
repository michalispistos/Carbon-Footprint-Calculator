import 'dart:async';
import 'dart:convert' show json;

import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'check_item.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile'
  ],
);

class LoginPage extends StatefulWidget {
  final bool signOut;

  const LoginPage({Key? key, required bool this.signOut}) : super(key: key);

  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.signOut) {
      _handleSignOut();
    }
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        globals.currentUser = _currentUser;
        final prefs = await SharedPreferences.getInstance();
        globals.headers["cookie"] = prefs.getString("cookie")!;
        globals.userid = prefs.getInt("userid");
        print(globals.userid);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signIn().then((result) {
        result!.authentication.then((googleKey) async {
          String body = json.encode({"token": googleKey.idToken});
          http.Response response = await http.post(
            Uri.parse("http://footprintcalculator.herokuapp.com/auth/login"),
            headers: {"Content-Type": "application/json"},
            body: body,
          );

          final cookie = response.headers["set-cookie"];
          if (cookie!.isNotEmpty) {
            globals.headers["cookie"] = cookie;
          }
          int userid = json.decode(response.body)["userid"];
          globals.userid = userid;
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("cookie", cookie);
          prefs.setInt("userid", userid);
        }).catchError((err) {
          print(err);
        });
      }).catchError((err) {
        print(err);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect().then((res) async {
      http.Response response = await http.post(
        Uri.parse("http://footprintcalculator.herokuapp.com/auth/logout"),
        headers: globals.headers,
      );
      globals.headers["cookie"] = "";
      print("LOGOUT");
      globals.userid = null;
    });
  }

  Widget _buildBody() {
    ThemeData themeData = Theme.of(context);
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return ItemCalculationStart(type:"");
    } else {
      return Stack(children: <Widget>[
        CustomPaint(size: Size.infinite, painter: CircleBackgroundPainter()),
        Column(
          children: <Widget>[
            addVerticalSpace(100),
            // Text("Welcome to Carbon Footprint Calculator",
            //          textAlign: TextAlign.center,
            //          style: TextStyle(
            //            color: Colors.black,
            //            fontWeight: FontWeight.bold,
            //            fontSize: 20,
            //          )),
            //
            //      // child: Text("Carbon Footprint Calculator",
            //      //     textAlign: TextAlign.center,
            //      //     style: TextStyle(
            //      //       color: Colors.black,
            //      //       fontWeight: FontWeight.bold,
            //      //       fontSize: 20,
            //      //     ))),
            //  addVerticalSpace(50),
            const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 100, 0),
                child: Text("Buy smart and save the environment",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.2,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ))),
            addVerticalSpace(75),
            Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Container(
                    width: 225.0,
                    height: 225.0,
                    child: Image.asset('images/leaf.png'))),
            addVerticalSpace(65),
            FlatButton(
              child: const Text('Sign In',
                  style: TextStyle(
                    fontSize: 17,
                  )),
              color: const Color(0xfffffaca),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0)),
              onPressed: _handleSignIn,
            ),
          ],
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(),
    ));
  }
}

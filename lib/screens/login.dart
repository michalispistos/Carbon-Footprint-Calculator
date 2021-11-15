import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert' show json;

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
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        globals.currentUser = _currentUser;
      }
    });
    _googleSignIn.signInSilently();
  }


  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signIn().then((result){
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
          globals.userid = json.decode(response.body)["userid"];
        }).catchError((err){
          print(err);
        });
      }).catchError((err){
        print(err);
      });

    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {

    _googleSignIn.disconnect().then((res) async {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:3000/auth/logout"),
        headers: {"Content-Type": "application/json"},
      );
      globals.headers["cookie"] = "";
      globals.userid = null;
   });

  }

  Widget _buildBody() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return ItemCalculationStart();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("Welcome to Carbon Footprint Calculator"),
          ElevatedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
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
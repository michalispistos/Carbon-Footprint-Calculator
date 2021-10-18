import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandDetails extends StatelessWidget {
  const BrandDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Brand Details"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: <Widget>[
      Text("brand name here"),
      Material(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Text("l"),
      )),
    ]));
  }
}

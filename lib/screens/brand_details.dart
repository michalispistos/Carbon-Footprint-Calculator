import 'package:carbon_footprint_calculator/utils/brand_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandDetails extends StatelessWidget {
  const BrandDetails({Key? key, required this.brandInfo}) : super(key: key);

  final BrandInfo brandInfo;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(brandInfo.name),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: <Widget>[
      Text(brandInfo.description),
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

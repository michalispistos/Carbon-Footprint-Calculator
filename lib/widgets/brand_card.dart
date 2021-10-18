import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  const BrandCard(
      {Key? key,
        required this.cardColor,
        required this.title,
        required this.rating,
        required this.description})
      : super(key: key);

  final Color cardColor;
  final String title;
  final int rating;
  final String description;

  @override
  Widget build(BuildContext context) {
    return BorderIcon(
      child: Stack(children: <Widget>[
        Text(title),
      ]),
      bgColor: cardColor,
    );
  }
}
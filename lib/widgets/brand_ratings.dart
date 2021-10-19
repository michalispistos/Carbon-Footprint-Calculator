import 'package:flutter/material.dart';

class BrandRatings extends StatelessWidget {

  final int stars;
  const BrandRatings({Key? key, required this.stars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Image> starIcons = [];

    for (var i = 0; i < stars; i++) {
      starIcons.add(
        Image.asset('images/leaf.png', scale: 17),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: starIcons
      ),
    );
  }

}
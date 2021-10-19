import 'package:flutter/material.dart';

class BrandRatings extends StatelessWidget {

  final int stars;
  const BrandRatings({Key? key, required this.stars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Image> starIcons = [];

    for (var i = 0; i < stars; i++) {
      starIcons.add(
        Image.asset('images/leaf.png',
            width: 25,
            height: 25
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 2.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,

          children: starIcons
        ),
      ),
    );
  }

}
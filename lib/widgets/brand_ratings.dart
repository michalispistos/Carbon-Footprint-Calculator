import 'package:flutter/material.dart';

class BrandRatings extends StatelessWidget {

  final int rating;
  final String imageUrl;
  const BrandRatings({Key? key, required this.rating, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Image> starIcons = [];

    for (var i = 0; i < rating; i++) {
      starIcons.add(
        Image.asset(imageUrl,
            width: 24,
            height: 24
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
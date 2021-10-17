import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/brand_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandsGrid extends StatelessWidget {
  const BrandsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        BrandCard(
          description: "gucci mane",
          title: 'gucci',
          rating: 4,
          cardColor: CustomTheme.lightTheme.backgroundColor,
        ),
        BrandCard(
          description: "gucci mane",
          title: 'prada',
          rating: 4,
          cardColor: CustomTheme.lightTheme.backgroundColor,
        ),
        BrandCard(
          description: "gucci mane",
          title: 'tommy',
          rating: 4,
          cardColor: CustomTheme.lightTheme.backgroundColor,
        ),
        BrandCard(
          description: "gucci mane",
          title: 'burberry',
          rating: 4,
          cardColor: CustomTheme.lightTheme.backgroundColor,
        ),
        BrandCard(
          description: "gucci mane",
          title: 'louis vuitton',
          rating: 4,
          cardColor: CustomTheme.lightTheme.backgroundColor,
        ),

      ],
    );
  }
}
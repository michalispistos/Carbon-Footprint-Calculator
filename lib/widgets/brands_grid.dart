import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/utils/brand_sample_data.dart';
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
      children: brandData.map((brand) => BrandCard(brandInfo: brand,)).toList(),
    );
  }
}
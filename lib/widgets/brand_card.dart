import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/screens/brand_details.dart';
import 'package:carbon_footprint_calculator/utils/brand_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {

  final dynamic brandInfo;

  const BrandCard(
      {Key? key,
        required this.brandInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BrandDetails()),
        );
      },
      child: BorderIcon(
        child: Stack(
          children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 12.0,
            child: Image.asset(
              brandInfo.logoPath,
            ),
          ),
          ],
        ),
        bgColor: themeData.primaryColorLight.withOpacity(1),
      ),

    );
  }
}



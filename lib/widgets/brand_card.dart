import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/screens/brand_details.dart';
import 'package:carbon_footprint_calculator/utils/brand_info.dart';
import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/brand_ratings.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  final dynamic brandInfo;

  const BrandCard({Key? key, required this.brandInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BrandDetails(brandInfo: brandInfo)),
        );
      },
      child: BorderIcon(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(brandInfo.logoPath),
                          //fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      )),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        brandInfo.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: CustomTheme.COLOR_BLACK,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            addVerticalSpace(10),
            Row(
              children: [
                const Text("Eco Rating:",
                style: TextStyle(
                  color: CustomTheme.COLOR_BLACK,
                )),
                BrandRatings(stars: brandInfo.rating),
              ],
            ),
            addVerticalSpace(10),
          ],
        ),
        bgColor: const Color(0xfffffaca),
      ),
    );
  }
}

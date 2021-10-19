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
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(brandInfo.logoPath),
                          //fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.pink.shade50.withAlpha(100), width: 1)
                      )),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      brandInfo.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: CustomTheme.COLOR_BLACK,
                        fontWeight: FontWeight.bold,
                        height: 1.2
                      ),
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(5),
            Container(
              width: 150,
              height: 30,
              decoration: const BoxDecoration(
                color: CustomTheme.COLOR_WHITE,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100)
                ),
                boxShadow: [
                  BoxShadow(
                    color: CustomTheme.COLOR_GREY,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: BrandRatings(stars: brandInfo.rating),
            ),
            addVerticalSpace(10),
            Text(
              brandInfo.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 10.0,
                color: CustomTheme.COLOR_BLACK,
              ),
            ),
      ],
        ),
        bgColor: const Color(0xfffffaca),
      ),
    );
  }
}

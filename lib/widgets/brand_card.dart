import 'package:carbon_footprint_calculator/screens/brand_details.dart';
import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/brand_ratings.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  final dynamic topPick;

  const BrandCard({Key? key, required this.topPick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BrandDetails(topPick.id)),
        );
      },
      child: Container(
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
                            image: AssetImage(topPick.imageUrl),
                            //fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.pink.shade50.withAlpha(100), width: 1)
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      topPick.name,
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
                // boxShadow: [
                //   BoxShadow(
                //     color: CustomTheme.COLOR_GREY,
                //     spreadRadius: 1,
                //     blurRadius: 1,
                //     offset: Offset(0, 1), // changes position of shadow
                //   ),
                // ],
              ),
              child:BrandRatings(stars: topPick.ethicalRating),
            ),
            addVerticalSpace(10),
            Expanded(
                child:Text(
                  // TODO: CHANGE THIS
                  topPick.imageUrl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 11.0,
                    height: 1.2,
                    color: CustomTheme.COLOR_BLACK,
                  ),
                )),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(200),
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: const Color(0xfffffaca),
            borderRadius: const BorderRadius.all(Radius.circular(15.0))),
      ),
    );
  }
}

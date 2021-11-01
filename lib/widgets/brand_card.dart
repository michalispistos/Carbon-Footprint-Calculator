import 'package:carbon_footprint_calculator/screens/brand_details.dart';
import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/utils/brands_request.dart';
import 'package:carbon_footprint_calculator/widgets/brand_ratings.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatefulWidget {
  final dynamic topPick;

  const BrandCard({Key? key, required this.topPick}) : super(key: key);

  @override
  _BrandCardState createState() => _BrandCardState();
}

class _BrandCardState extends State<BrandCard> {
  late Future<BrandInfo> futureBrandInfo;

  @override
  void initState() {
    futureBrandInfo = fetchBrand(widget.topPick.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Center(
      child: FutureBuilder<BrandInfo>(
        future: futureBrandInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BrandDetails(brandInfo: snapshot.data!)),
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
                                    image: NetworkImage(snapshot.data!.logoUrl),
                                    //AssetImage(topPick.imageUrl),
                                    //fit: BoxFit.fill,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.pink.shade50.withAlpha(100),
                                      width: 1))),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.topPick.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  color: CustomTheme.COLOR_BLACK,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(4),
                    Container(
                      width: 150,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: CustomTheme.COLOR_WHITE,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: CustomTheme.COLOR_GREY,
                        //     spreadRadius: 1,
                        //     blurRadius: 1,
                        //     offset: Offset(0, 1), // changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: BrandRatings(
                          rating: widget.topPick.ethicalRating,
                          imageUrl: 'images/leaf.png'),
                    ),
                    addVerticalSpace(20),
                    Expanded(
                        child: Text(
                      snapshot.data!.ethicalInfo1,
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
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: const Color(0xfffffaca),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(15.0))),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

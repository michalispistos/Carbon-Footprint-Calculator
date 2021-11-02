import 'dart:developer';

import 'package:carbon_footprint_calculator/utils/brands_request.dart';
import 'package:carbon_footprint_calculator/widgets/brand_card.dart';
import 'package:carbon_footprint_calculator/widgets/brand_ratings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandDetails extends StatelessWidget {
  final BrandInfo brandInfo;

  const BrandDetails({Key? key, required this.brandInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            backgroundColor: const Color(0xFFE9E9E9),
            expandedHeight: 300,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(40)),
                child: Image.network(brandInfo.imageUrl),
                // child: Image.asset(
                //   brandInfo.logoPath,
                //   fit: BoxFit.fitWidth,
                // ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  // title: Text(
                  //   // TODO LOCATION
                  //   brandInfo.location[0].name,
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.w800,
                  //     fontSize: 13,
                  //     color: Colors.blueGrey,
                  //   ),
                  // ),
                  subtitle: Text(
                    brandInfo.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          BrandRatings(
                            rating: brandInfo.ethicalRating,
                            imageUrl: 'images/leaf.png',
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          BrandRatings(
                            rating: brandInfo.priceRating,
                            imageUrl: 'images/dollar-sign.png',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "ABOUT",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Html(
                      data: brandInfo.ethicalInfo2,
                      style:{
                        "body": Style(
                          color: const Color.fromRGBO(91, 91, 91, 1),
                        )
                      }

                    ),
                    // child: Text(
                    //   brandInfo.description,
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "STYLES",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  child: Text(
                    brandInfo.categoriesToString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(91, 91, 91, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 32),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _launchURL(brandInfo.websiteUrl);
                            log(brandInfo.websiteUrl);
                          },
                          child: const Text('SHOP NOW'),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 16, right: 16, bottom: 32),
                    //   child: Center(
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         // TODO GOODONYOULINK
                    //         _launchURL(brandInfo.websiteUrl);
                    //         log(brandInfo.websiteUrl);
                    //       },
                    //       child: const Text('READ MORE'),
                    //     ),
                    //   ),
                    //),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _launchURL(_url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
/*
Material(
child: InkWell(
onTap: () {
Navigator.pop(context);
},
child: Text("l"),
)),*/

import 'dart:developer';

import 'package:carbon_footprint_calculator/utils/brand_info.dart';
import 'package:carbon_footprint_calculator/widgets/brand_card.dart';
import 'package:carbon_footprint_calculator/widgets/brand_ratings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandDetails extends StatelessWidget {
  const BrandDetails({Key? key, required this.brandInfo}) : super(key: key);

  final BrandInfo brandInfo;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            backgroundColor: const Color(0xFF200087),
            expandedHeight: 300,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(40)),
                child: Image.asset(
                  brandInfo.logoPath,
                  fit: BoxFit.fitWidth,
                ),
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
                  title: Text(
                    brandInfo.basedIn,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                  ),
                  subtitle: Text(
                    brandInfo.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(
                            width: 30,
                          ),
                          BrandRatings(stars: brandInfo.rating)
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(
                            width: 140,
                          ),
                          Text(
                            brandInfo.priceRange,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
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
                    child: Text(
                      brandInfo.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                    brandInfo.style,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
                            _launchURL(brandInfo.websiteLink);
                            log(brandInfo.websiteLink);
                          },
                          child: const Text('SHOP NOW'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 32),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _launchURL(brandInfo.goodOnYouLink);
                            log(brandInfo.goodOnYouLink);
                          },
                          child: const Text('READ MORE'),
                        ),
                      ),
                    ),
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

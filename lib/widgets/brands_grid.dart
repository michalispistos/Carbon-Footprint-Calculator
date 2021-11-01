import 'package:carbon_footprint_calculator/utils/brand_sample_data.dart';
import 'package:carbon_footprint_calculator/utils/top_picks.dart';
import 'package:carbon_footprint_calculator/widgets/brand_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BrandsGrid extends StatelessWidget {
  const BrandsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TopPicks>>(
        future: fetchTopPicks(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: snapshot.data!.map((brand) => BrandCard(topPick: brand)).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
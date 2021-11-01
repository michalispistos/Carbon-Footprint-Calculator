import 'package:carbon_footprint_calculator/utils/top_picks.dart';
import 'package:carbon_footprint_calculator/widgets/brand_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;

class BrandsGrid extends StatefulWidget {
  const BrandsGrid({
    Key? key,
  }) : super(key: key);

  @override
  _BrandsGridState createState() => _BrandsGridState();
}

class _BrandsGridState extends State<BrandsGrid>
    with AutomaticKeepAliveClientMixin<BrandsGrid> {
  late Future<List<TopPicks>> futureTopPicks;

  @override
  void initState() {
    futureTopPicks = fetchTopPicks(http.Client());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    globals.tab = 2;
    return Scaffold(
      body: FutureBuilder<List<TopPicks>>(
        future: futureTopPicks,
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
              children: snapshot.data!
                  .map((brand) => BrandCard(topPick: brand))
                  .toList(),
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

  @override
  bool get wantKeepAlive => true;
}

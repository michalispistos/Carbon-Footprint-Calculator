import 'package:carbon_footprint_calculator/utils/top_picks.dart';
import 'package:carbon_footprint_calculator/widgets/brand_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

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
    super.initState();
    futureTopPicks = fetchTopPicks(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TopPicks>>(
        future: futureTopPicks,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return Column(children: [
              Expanded(
                  child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: snapshot.data!
                    .map((brand) => BrandCard(topPick: brand))
                    .toList(),
              )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Information source: "),
                InkWell(
                    child: const Text(
                      "https://goodonyou.eco/",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () => launch('https://goodonyou.eco/'))
              ])
            ]);
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

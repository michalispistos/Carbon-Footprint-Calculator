import 'package:carbon_footprint_calculator/utils/top_picks.dart';
import 'package:carbon_footprint_calculator/widgets/brand_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<TopPicks> topPicks = [];

  @override
  void initState() {
    futureTopPicks = fetchTopPicks();
    super.initState();
    fetchTopPicks().then((topPicksFromServer) {
      setState(() {
        topPicks = topPicksFromServer;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    globals.tab = 2;

    return Column(children: [
      Expanded(
          child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children:
            topPicks.map((brand) => BrandCard(topPick: brand)).toList(),
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
  }

  @override
  bool get wantKeepAlive => true;
}
    // Padding(
    //   padding: const EdgeInsets.only(left: 30, right: 30),
    //   child: CustomPriceFilter(prices: Price.prices),
    // ),

    // Padding(
    //     padding: const EdgeInsets.only(left: 30, right: 30),
    //     child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: Price.prices
    //             .map(
    //               (price) => InkWell(
    //             onTap: () {
    //               setState(() {
    //                 filteredTopPicks = topPicks
    //                     .where((tp) => (tp.price == price.id))
    //                     .toList();
    //               });
    //             },
    //             child: Container(
    //               margin: const EdgeInsets.only(
    //                 top: 10,
    //                 bottom: 10,
    //               ),
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 40,
    //                 vertical: 10,
    //               ),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 //borderRadius: BorderRadius.circular(5),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.grey.withAlpha(200),
    //                     spreadRadius: 1,
    //                     blurRadius: 12,
    //                     offset: const Offset(
    //                         0, 1), // changes position of shadow
    //                   ),
    //                 ],
    //                 // borderRadius:
    //                 //     const BorderRadius.all(Radius.circular(15.0)),
    //               ),
    //               child: Text(
    //                 price.price,
    //                 style: Theme.of(context).textTheme.headline5,
    //               ),
    //             ),
    //           ),
    //         )
    //             .toList())),

    //   return Column(
    //     children: [
    //       //buildFilter(),
    //       Scaffold(
    //         body: FutureBuilder<List<TopPicks>>(
    //           future: futureTopPicks,
    //           builder: (context, snapshot) {
    //             if (snapshot.hasError) {
    //               return const Center(
    //                 child: Text('An error has occurred!'),
    //               );
    //             } else if (snapshot.hasData) {
    //               return Column(children: [
    //                 Expanded(
    //                     child: GridView.count(
    //                   primary: false,
    //                   padding: const EdgeInsets.all(20),
    //                   crossAxisSpacing: 10,
    //                   mainAxisSpacing: 10,
    //                   crossAxisCount: 2,
    //                   children: snapshot.data!
    //                       .map((brand) => BrandCard(topPick: brand))
    //                       .toList(),
    //                 )),
    //                 Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    //                   const Text("Information source: "),
    //                   InkWell(
    //                       child: const Text(
    //                         "https://goodonyou.eco/",
    //                         style: TextStyle(
    //                           color: Colors.blue,
    //                           decoration: TextDecoration.underline,
    //                         ),
    //                       ),
    //                       onTap: () => launch('https://goodonyou.eco/'))
    //                 ])
    //               ]);
    //             } else {
    //               return const Center(
    //                 child: CircularProgressIndicator(),
    //               );
    //             }
    //           },
    //         ),
    //       ),
    //     ],
    //   );


// class CustomPriceFilter extends StatelessWidget {
//   final List<Price> prices;
//   const CustomPriceFilter({
//     Key? key,
//     required this.prices,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: prices
//             .map(
//               (price) => InkWell(
//                 onTap: () {},
//                 child: Container(
//                   margin: const EdgeInsets.only(
//                     top: 10,
//                     bottom: 10,
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     //borderRadius: BorderRadius.circular(5),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withAlpha(200),
//                         spreadRadius: 1,
//                         blurRadius: 12,
//                         offset:
//                             const Offset(0, 1), // changes position of shadow
//                       ),
//                     ],
//                     borderRadius: const BorderRadius.all(Radius.circular(15.0)),
//                   ),
//                   child: Text(
//                     price.price,
//                     style: Theme.of(context).textTheme.headline5,
//                   ),
//                 ),
//               ),
//             )
//             .toList());
//   }
// }

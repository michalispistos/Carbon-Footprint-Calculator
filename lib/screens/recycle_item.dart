import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carbon_footprint_calculator/screens/check_item.dart';
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:carbon_footprint_calculator/screens/your_score.dart';
import 'package:carbon_footprint_calculator/screens/recycle_items.dart';
import 'package:http/http.dart' as http;

class RecycleItem extends StatelessWidget {
  final Clothing clothing;

  RecycleItem(this.clothing);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Flexible(
          child: Padding(
              padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
              child: Text(
                'Recycle',
                style: TextStyle(
                  fontSize: 20,
                ),
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.fade,
              )),
        )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          addVerticalSpace(75),
          Center(
            child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('images/recycling_symbol.png')),
          ),
          addVerticalSpace(40),
          Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Text(
                  "You've lowered your carbon footprint! Carbon score: " +
                      2.toString(),
                  style: themeData.textTheme.headline3)),
          addVerticalSpace(30),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(
              "Recycling clothes reduces landfill, conserves energy, and can lower "
              "your carbon footprint. Nearly 100% of textiles and clothing is recyclable "
              "but only 15% of consumer used clothing is recycled.",
              style: TextStyle(
                  fontSize: 15, color: const Color.fromRGBO(91, 91, 91, 1.0)),
            ),
          ),
          addVerticalSpace(30),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text("Information source: "),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: InkWell(
                  child: const Text(
                    "https://www.thebalancesmb.com/textile-recycling-facts-and-figures-2878122",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () => launch(
                      'https://www.thebalancesmb.com/textile-recycling-facts-and-figures-2878122'))),
          MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              elevation: 5.0,
              child: const Text("DONE"),
              onPressed: () {
                removeClothes(context);
              })
        ]));
  }

  void removeClothes(context) async {
    await http.delete(
        Uri.parse(
            "https://footprintcalculator.herokuapp.com/clothes/${clothing.id}/recycle"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }).then((val) => {
          globals.tab = 1,
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const ItemCalculationStart()),
            (Route<dynamic> route) => false,
          )
        });
  }
}

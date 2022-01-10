import 'package:carbon_footprint_calculator/screens/recycle_items.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carbon_footprint_calculator/screens/check_item.dart';
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:carbon_footprint_calculator/screens/your_score.dart';
import 'package:http/http.dart' as http;

class ThrowAwayItem extends StatelessWidget {
  final Clothing clothing;
  ThrowAwayItem(this.clothing);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Flexible(
          child: Padding(
              padding: EdgeInsets.fromLTRB(55, 0, 0, 0),
              child: Text(
                'Throw away',
                style: TextStyle(
                  fontSize: 20,
                ),
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.fade,
              )),
        )),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(75),
            Center(
              child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('images/bin.png')),
            ),
            addVerticalSpace(40),
            Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Throwing way this item will increase your carbon footprint by: ",
                    style: themeData.textTheme.headline3,
                    children: <TextSpan>[
                      TextSpan(
                          text:
                          clothing.carbonScore.toStringAsFixed(2),
                          style: themeData.textTheme.headline3!
                              .copyWith(color: Color.fromRGBO(254, 96, 79, 1))),
                      TextSpan(text: "! New carbon score will be:"),
                    ],
                  ),
                )),
            calculateNewUsersCarbonScore(clothing.carbonScore, false),
            addVerticalSpace(30),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Once you throw your clothes in the trash they end up in "
                "landfills where they take decades to degrade. In the "
                "process, they emit greenhouse gases. Clothing in landfills "
                "emits methane and pollutes the soil and waters with "
                "plastic and chemicals while decomposing. "
                "Instead of throwing away your clothes, why not recycle or give "
                "them to those who need them?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: const Color.fromRGBO(91, 91, 91, 1.0)),
              ),
            ),
            addVerticalSpace(30),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: const Color(0xfffffaca),
              onPressed: () {
                globals.tab = 4;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemCalculationStart(type:"")),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Find a recycling centre near you',
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ),
            addVerticalSpace(20),
            // FlatButton(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(18.0)),
            //   color: const Color(0xfffffaca),
            //   onPressed: () {
            //     globals.tab = 4;
            //     Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const ItemCalculationStart()),
            //       (Route<dynamic> route) => false,
            //     );
            //   },
            //   child: const Text('Find a donation centre near you',
            //       style: TextStyle(
            //         fontSize: 17,
            //       )),
            // ),
            // addVerticalSpace(20),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: const Color.fromRGBO(254, 96, 79, 1),
              onPressed: () {
                removeClothes(context);
              },
              child: const Text('Throw away item',
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ),
            addVerticalSpace(30),
            const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Information source: ")),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                    child: const Text(
                      "https://www.ecofriendlyhabits.com/textile-and-fashion-waste-statistics/",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () => launch(
                        'https://www.ecofriendlyhabits.com/textile-and-fashion-waste-statistics/'))),
          ],
        )));
  }

  void removeClothes(context) async {
    await http.delete(
        Uri.parse(
            "https://footprintcalculator.herokuapp.com/clothes/${clothing.id}/throw-away"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }).then((val) => {
          globals.tab = 1,
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>ItemCalculationStart(type:"")),
            (Route<dynamic> route) => false,
          )
        });
  }
}

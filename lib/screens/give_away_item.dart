import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GiveAwayItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Flexible(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                  child: Text(
                    'Give away, sell or donate item',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )),
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(75),
            Center(
              child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('images/give_away_clothes.jpg')),
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
                "1 in 2 people throw away their unwanted clothes "
                    "instead of giving away or donating to those who need them. "
                    "This results in 64% of the total amount of garments "
                    "produced each year ending up in landfills.",
                style: TextStyle(
                    fontSize: 15, color: const Color.fromRGBO(91, 91, 91, 1.0)),
              ),
            ),
            addVerticalSpace(30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Information source: "),
              InkWell(
                  child: const Text(
                    "https://www.ecofriendlyhabits.com/textile-and-fashion-waste-statistics/",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () =>
                      launch(
                          'https://www.ecofriendlyhabits.com/textile-and-fashion-waste-statistics/'))
            ])
          ],
        ));
  }
}

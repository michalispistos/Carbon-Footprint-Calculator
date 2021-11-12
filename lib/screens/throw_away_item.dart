import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ThrowAwayItem extends StatelessWidget {
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
                    'Throw away item',
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
                  child: Image.asset('images/bin.png')),
            ),
            addVerticalSpace(40),
            Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Text(
                    "Throwing away this item would increase your carbon footprint by 2. Carbon score: " +
                        2.toString(),
                    style: themeData.textTheme.headline3)),
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
                style: TextStyle(
                    fontSize: 15, color: const Color.fromRGBO(91, 91, 91, 1.0)),
              ),
            ),
            addVerticalSpace(30),
            FlatButton(
              shape:
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: const Color(0xfffffaca),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const ItemInfoPage()),
                // );
              },
              child: const Text('Find a recycling centre near you',
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ),
            addVerticalSpace(20),
            FlatButton(
              shape:
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: const Color(0xfffffaca),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ItemInfoPage()),
                // );
              },
              child: const Text('Find a donation centre near you',
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ),
            addVerticalSpace(20),
            FlatButton(
              shape:
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: const Color(0xfff82d2d),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThrowAwayItem()),
                );
              },
              child: const Text('Throw away item',
                  style: TextStyle(
                    fontSize: 17,
                  )),
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
            ]),
          ],
        ));
  }
}

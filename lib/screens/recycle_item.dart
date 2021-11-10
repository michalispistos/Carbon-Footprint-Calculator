import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: new RecycleItem()));

class RecycleItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(70),
            Center(
              child: SizedBox(
                  width: size.width - 150,
                  height: size.height / 2 - 20,
                  child: Image.asset('images/recycling_symbol.png')),
            ),
            addVerticalSpace(40),
            Text(
                "You've lowered your carbon footprint! Carbon score: " +
            2.toString(),
                style: themeData.textTheme.headline3),
            addVerticalSpace(30),
            const Text(
              "Recycling clothes reduces landfill, conserves energy, and can lower "
                  "your carbon footprint. Did you know that if we recycled 100 "
                  "million lbs of our pre-loved clothing that would be the same "
                  "as taking 35,000 cars off of the road?"
            )
          ],
        ));
  }

  // double getCarbonFootprint(int userID) {}


}
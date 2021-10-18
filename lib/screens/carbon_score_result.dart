import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/utils/carbon_calculator.dart';
import 'package:carbon_footprint_calculator/utils/carbon_footprint.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';

class CarbonScoreResult extends StatelessWidget {
  final Item item;
  final CarbonFootprint carbonFootprint = CarbonFootprint(calculator : DefaultCarbonCalculator());

  CarbonScoreResult({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [addVerticalSpace(70),
            Center(
              child: SizedBox(
                  width: size.width - 150,
                  height: size.height/2 - 20,
                  child: Image.asset('images/phonecart.png')),
            ), addVerticalSpace(40),
            Text("Carbon score: " + carbonFootprint.getFootprint(item).toStringAsFixed(2), style: themeData.textTheme.headline3),
            addVerticalSpace(30),
            TextButton(onPressed: () {}, child: const Text("Add this to your items?"))
          ],
        ));
  }
}

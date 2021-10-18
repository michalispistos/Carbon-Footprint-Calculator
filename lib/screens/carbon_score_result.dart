import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';

class CarbonScoreResult extends StatelessWidget {
  const CarbonScoreResult({Key? key}) : super(key: key);

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
                  child: Image.asset('images/phonecart.png')),
            ), addVerticalSpace(40),
            Text("Carbon score: N/A", style: themeData.textTheme.headline3),
            addVerticalSpace(30),
            TextButton(onPressed: () {}, child: const Text("Add this to your items?"))
          ],
        ));
  }
}

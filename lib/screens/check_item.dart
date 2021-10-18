import 'package:carbon_footprint_calculator/screens/item_details.dart';
import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => {
  WidgetsFlutterBinding.ensureInitialized(),
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]),

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Carbon Footprint Calculator",
      theme: CustomTheme.lightTheme,
      home: const ItemCalculationStart()))};

class ItemCalculationStart extends StatelessWidget {
  const ItemCalculationStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(children: <Widget>[
          CustomPaint(size: Size.infinite, painter: CircleBackgroundPainter()),
          Column(
            children: [
              addVerticalSpace(60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          BorderIcon(
                              height: 40,
                              width: 40,
                              bgColor: const Color(0xffffe8ec),
                              child: Image.asset('images/leaf.png')),
                          addHorizontalSpace(10),
                          //TODO: login system xd
                          Text("Hi, User",
                              style: themeData.textTheme.headline4),
                        ],
                      ),
                      const BorderIcon(
                          height: 50,
                          width: 50,
                          child:
                          Icon(Icons.menu, color: CustomTheme.COLOR_BLACK))
                    ]),
              ),
              addVerticalSpace(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Check your item",
                        style: themeData.textTheme.headline1,
                        textAlign: TextAlign.left),
                  ],
                ),
              ),
              addVerticalSpace(size.height / 2 - 200),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Flexible(
                      child: Text(
                        "We'll ask you a few questions to calculate the impact of your item.",
                        textAlign: TextAlign.center,
                        style: themeData.textTheme.headline3,
                      ))
                ]),
              ),
              addVerticalSpace(25),
              ElevatedButton(
                child: const Text('Start'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ItemInfoPage()),
                  );
                },
              ),
            ],
          )
        ]),
      ),
    );
  }
}

class CircleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Offset sets each circle's center
    canvas.drawCircle(
        Offset(size.width - 40, 20), 150, Paint()..color = const Color(0xffffe3d3));
    canvas.drawCircle(Offset(size.width / 2, size.height), 300,
        Paint()..color = const Color(0xffe7f6ff));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
import 'dart:collection';

import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Carbon Footprint Calculator",
    theme: CustomTheme.lightTheme,
    home: ItemCalculationStart()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget inputSections = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonRow(color, Icons.call, 'CALL'),
        _buildButtonRow(color, Icons.near_me, 'ROUTE'),
        _buildButtonRow(color, Icons.share, 'SHARE'),
      ],
    );

    // return MaterialApp(
    //   theme: CustomTheme.lightTheme,
    //   title: 'Welcome to Flutter',
    home:
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Carbon Footprint Calculator'),
          ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/coatrack.png'),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text("Type of product")]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Type of product"),
                ))
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text("Weight of product")]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Weight in kg"),
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text("Material"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Expanded(
                child:
                    SizedBox(width: 200, height: 100, child: MaterialsList()))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 350,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Calculate carbon score'),
                ))
          ]),
        ],
      ),
      // ),
    );
  }

  Row _buildButtonRow(Color color, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 1),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class MaterialsList extends StatefulWidget {
  const MaterialsList({Key? key}) : super(key: key);

  @override
  _MaterialsListState createState() => _MaterialsListState();
}

class _MaterialsListState extends State<MaterialsList> {
  HashMap materials_to_percentages = new HashMap<String, double>();
  String valueChoose = "Choose material";

  List<String> materials = [
    "Wool",
    "Acrylic",
    "Viscose",
    "Cotton",
    "Silk",
    "polyester",
    "Polyurethane",
    "Flax linen"
  ];

  Future createDialog(BuildContext context) {
    TextEditingController controller1 = TextEditingController();
    TextEditingController controller2 = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(""),
            content: Container(
                height: 150,
                child: Column(children: [
                  Text("Material"),
                  DropdownButton<String>(
                    // value:valueChoose,
                    onChanged: (newValue) {
                      setState(() {
                        valueChoose = newValue.toString();
                      });
                    },
                    items: materials.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  // TextField(
                  //   controller: controller1,
                  // ),
                  SizedBox(height: 10),
                  Text("Percentage (%)"),
                  TextField(
                    controller: controller2,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                  )
                ])),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("SUBMIT"),
                onPressed: () {
                  Navigator.of(context)
                      .pop([valueChoose, controller2.text.toString()]);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 10,
        child: Column(
          children: [
            Expanded(
                child: Center(
                    child: FlatButton(
              onPressed: () {
                createDialog(context).then((value) => {
                      setState(() {
                        materials_to_percentages.putIfAbsent(
                            value[0], () => double.parse(value[1]));
                      }),
                      materials.remove(value[0])
                    });
              },
              child: Text("Add"),
            ))),
            Expanded(child: _displayMap()),
          ],
        ));
  }

  Widget _displayMap() {
    return ListView.builder(
      itemCount: materials_to_percentages.length,
      itemBuilder: (BuildContext context, int index) {
        String key = materials_to_percentages.keys.elementAt(index);
        return Column(
          children: <Widget>[
            ListTile(
              title: new Text("$key"),
              subtitle: new Text("${materials_to_percentages[key]}%"),
            ),
            const Divider(
              height: 0.2,
            ),
          ],
        );
      },
    );
  }
}

class ItemCalculationStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Carbon Footprint Calculator'),
        // ),
        body: Stack(children: <Widget>[
          CustomPaint(size: Size.infinite, painter: CircleBackgroundPainter()),
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                    MaterialPageRoute(builder: (context) => MyApp()),
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
        Offset(size.width - 40, 20), 150, Paint()..color = Color(0xffffe3d3));
    canvas.drawCircle(Offset(size.width / 2, size.height), 300,
        Paint()..color = Color(0xffe7f6ff));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

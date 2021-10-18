import 'dart:collection';

import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/utils/carbon_calculator.dart';
import 'package:carbon_footprint_calculator/utils/carbon_footprint.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:collection';

import 'data/item.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Carbon Footprint Calculator",
    theme: CustomTheme.lightTheme,
    home: const ItemCalculationStart()));

class ItemInfoPage extends StatelessWidget {
  const ItemInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
      title: 'Welcome to Flutter',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Complete some details about your item'),
          ),
          resizeToAvoidBottomInset: false,
          body: const ItemDetails()),
    );
  }
}

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key}) : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  TextEditingController weightController = TextEditingController();
  TextEditingController itemTypeController = TextEditingController();
  CarbonFootprint carbonFootprint = CarbonFootprint(calculator : DefaultCarbonCalculator());
  Map<String, double> materialsToPercentages = HashMap();
  String dropdownValue = 'Acrylic';
  List<String> materials = [
    'Acrylic',
    'Cotton',
    'Flax linen',
    'Polyester',
    'Polyurethane',
    'Silk',
    'Viscose',
    'Wool',
  ];

  calculateTotalPercentages() {
    double totalPercentage = 0;
    for (var v in materialsToPercentages.values) {
      totalPercentage += v;
    }
    return totalPercentage;
  }

  calculateCarbonScore() {
    if (calculateTotalPercentages() != 100) {
      createErrorDialog(context, "Percentages don't add up to 100");
    }
    String itemType = itemTypeController.text;
    if (double.tryParse(itemTypeController.text) == null) {
      // Should never occur?
      throw Exception("Invalid weight");
    }
    double itemWeight = double.parse(itemTypeController.text);
    Item item = Item(materialsToPercentages, itemType, itemWeight);

    // Pass item to new screen

    // carbonFootprint.getFootprint(item);
  }

  Future createErrorDialog(BuildContext context, String errorMessage) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: SizedBox(
              height: 20,
              child: Text(errorMessage),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                elevation: 5.0,
                child: const Text("CLOSE"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future createMaterialPercentageDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(""),
            content: SizedBox(
                height: 145,
                child: Column(children: [
                  const Text("Material"),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return DropdownButton(
                          hint: Text(dropdownValue),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.green),
                          underline: Container(
                            height: 2,
                            color: Colors.greenAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: materials.map((String value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                        );
                      }),
                  const SizedBox(height: 10),
                  const Text("Percentage (%)"),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 30,
                      child: TextField(
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            hintText: "i.e. 45%"),
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.black),
                        controller: controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}'))
                        ],
                      )),
                ])),
            actions: <Widget>[
              MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                elevation: 5.0,
                child: const Text("SUBMIT"),
                onPressed: () {
                  Navigator.of(context)
                      .pop([dropdownValue, controller.text.toString()]);
                },
              )
            ],
          );
        });
  }

  Widget _buildAddMaterialButton() {
    return FlatButton(
      color: const Color(0xfffffaca),
      shape: const CircleBorder(),
      onPressed: () {
        createMaterialPercentageDialog(context).then((value) => {
          setState(() {
            if (calculateTotalPercentages() + double.parse(value[1]) >
                100) {
              createErrorDialog(
                  context, "Percentages add up to more than 100");
            } else {
              materialsToPercentages.putIfAbsent(
                  value[0], () => double.parse(value[1]));
              materials.remove(value[0]);
              dropdownValue = materials[0];
            }
          }),
        });
      },
      child: const Text("+"),
    );
  }

  Widget _displayMaterialsToPercentageMap() {
    return ListView.builder(
      itemCount: materialsToPercentages.length,
      itemBuilder: (BuildContext context, int index) {
        String key = materialsToPercentages.keys.elementAt(index);
        return Column(
          children: <Widget>[
            SizedBox(
                width: 250,
                child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 40,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Text("$key: ${materialsToPercentages[key]}%"),
                        ),
                      )),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        materials.add(key);
                        materials.sort();
                        materialsToPercentages.remove(key);
                      });
                    },
                  )
                ])),
            const SizedBox(height: 10)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              height: 30,
              child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: "i.e. t-shirt"),
                  style: TextStyle(fontSize: 15.0, color: Colors.black)))
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Weight of product (kg)")]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              width: 200,
              height: 30,
              child: TextField(
                  controller: weightController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "i.e. 1.2",
                  ),
                  style: const TextStyle(fontSize: 15.0, color: Colors.black),
              )),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              margin: const EdgeInsets.only(
                left: 40,
              ),
              child: const Text("Materials")),
          _buildAddMaterialButton(),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: SizedBox(
                  width: 200,
                  height: 100,
                  child: _displayMaterialsToPercentageMap()))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              width: 350,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                color: const Color(0xfffffaca),
                onPressed: () {
                  calculateCarbonScore();
                },
                child: const Text('Calculate carbon score'),
              ))
        ]),
      ],
    );
  }
}



//first page

class ItemCalculationStart extends StatelessWidget {
  const ItemCalculationStart({Key? key}) : super(key: key);

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

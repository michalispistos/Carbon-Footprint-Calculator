import 'dart:collection';
import 'package:carbon_footprint_calculator/screens/carbon_score_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/item.dart';

class ItemInfoPage extends StatelessWidget {
  const ItemInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
          title: const Text('Complete some details about your item',
              style: TextStyle(
              fontSize: 15,
              )),
          ),
          resizeToAvoidBottomInset: false,
          body: const ItemDetails());
  }
}

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key}) : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  TextEditingController itemWeightController = TextEditingController();
  Map<String, double> materialsToPercentages = HashMap();
  String materialDropdownValue = 'Acrylic';
  String typeDropdownValue = 'Top';
  List<String> materials = [
    'Acrylic',
    'Cotton',
    'Flax Linen',
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
      return;
    }

    if (double.tryParse(itemWeightController.text) == null) {
      createErrorDialog(context, "Complete weight");
      throw Exception("Invalid weight");
    }

    double itemWeight = double.parse(itemWeightController.text);
    Item item = Item(materialsToPercentages, typeDropdownValue, itemWeight);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarbonScoreResult(item : item)),
    );
  }

  Future createErrorDialog(BuildContext context, String errorMessage) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: SizedBox(
              height: 20,
              child: Text(errorMessage,style: const TextStyle(
                fontSize: 15,
              ))),
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
                          hint: Text(materialDropdownValue),
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
                              materialDropdownValue = newValue!;
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
                      .pop([materialDropdownValue, controller.text.toString()]);
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
              materialDropdownValue = materials[0];
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          DropdownButton(
            hint: Text(typeDropdownValue),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.green),
            underline: Container(
              height: 2,
              color: Colors.green,
            ),
            onChanged: (String? newValue) {
              setState(() {
                typeDropdownValue = newValue!;
              });
            },
            items:  <String>['Top', 'Bottom', 'Shoes']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                child: Text(value),
                value: value,
              );
            }).toList(),
          )
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Weight of product (kg)")]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children:  [
          SizedBox(
              width: 200,
              height: 30,
              child: TextField(
                  controller: itemWeightController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "i.e. 1.2",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  style: const TextStyle(fontSize: 15.0, color: Colors.black)))
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
import 'dart:convert';

import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/utils/carbon_calculator.dart';
import 'package:carbon_footprint_calculator/utils/carbon_footprint.dart';
import 'package:carbon_footprint_calculator/screens/check_item.dart';
import 'package:carbon_footprint_calculator/screens/achievements.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class CarbonScoreResult extends StatefulWidget {
  final Item item;
  const CarbonScoreResult({Key? key, required this.item}) : super(key: key);

  @override
  _CarbonScoreResultState createState() => _CarbonScoreResultState();
}

class _CarbonScoreResultState extends State<CarbonScoreResult> {
  late final Item item;
  final CarbonFootprint carbonFootprint =
      CarbonFootprint(calculator: DefaultCarbonCalculator());
  String itemName = "";
  bool update = false;

  @override
  void initState() {
    super.initState();
    item = widget.item;

  }

  Future createItemAddedDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(""),
            content: SizedBox(
                height: 80,
                child: Column(children: [
                  const Text("Item Added to your Clothes",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  const SizedBox(height: 10),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    color: const Color(0xfffffaca),
                    onPressed: () {
                      globals.tab = 1;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemCalculationStart(type:"")),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Go to your clothes'),
                  )
                ])),
            actions: <Widget>[
              MaterialButton(
                color: const Color.fromRGBO(254, 96, 79, 1),
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

  Future createNameDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(""),
            content: SizedBox(
                height: 75,
                child: Column(children: [
                  const Text("Please input name of your Item",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 35,
                      child: TextField(
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            hintText: "i.e. Adidas shirt"),
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.black),
                        controller: controller..text = item.name,
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
                  Navigator.of(context).pop();
                  itemName = controller.text.toString();
                  if (itemName == "") {
                    createErrorDialog(context, "Complete item's name");
                  } else {
                    addClothes(itemName, item);
                    createItemAddedDialog(context);
                    setState(() {
                      ProgressDialog pr = new ProgressDialog(context);
                      pr.show();
                      Future.delayed(Duration(seconds: 3)).then((value) {
                        pr.hide();
                      });
                      update = true;
                    });
                  }
                },
              )
            ],
          );
        });
  }

  Future createErrorDialog(BuildContext context, String errorMessage) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error",
                style: TextStyle(
                  fontSize: 17,
                )),
            content: SizedBox(
                height: 20,
                child: Text(errorMessage,
                    style: const TextStyle(
                      fontSize: 15,
                    ))),
            actions: <Widget>[
              MaterialButton(
                color: const Color.fromRGBO(254, 96, 79, 1),
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    if(update){
      checkUpdateAchievements(context,"new_item");
      update = false;
    }

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
                  child: Image.asset('images/phonecart.png')),
            ),
            addVerticalSpace(30),
            Text(
                "Carbon score: " +
                    carbonFootprint.getFootprint(item).toStringAsFixed(2),
                style: themeData.textTheme.headline3),
            addVerticalSpace(30),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: const Color(0xfffffaca),
              onPressed: () {
                createNameDialog(context);
              },
              child: const Text('Add this to your clothes'),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: const Color(0xffe7f6ff),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      ItemCalculationStart(type:"")),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text('Exit without adding'),
            )
          ],
        ));
  }


  void addClothes(String itemName, Item item) async {
    final test = await http.post(
        Uri.parse("https://footprintcalculator.herokuapp.com/clothes"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': itemName,
          'type': item.type,
          'carbon_score': carbonFootprint.getFootprint(item),
          'owner': globals.userid
        }));
  }
}


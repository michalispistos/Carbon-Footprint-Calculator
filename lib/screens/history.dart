import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carbon_footprint_calculator/screens/your_score.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';

import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

Future<List<String>> fetchHistoryActions() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/history-actions/${globals.userid}"));
  if (response.statusCode == 200) {
    List<dynamic> list;
    if (jsonDecode(response.body)["history_actions"] == null) {
      list = [];
    } else {
      list = jsonDecode(response.body)["history_actions"];
    }

    return List<String>.from(list.map((x) => x.toString()).toList());
  } else {
    throw Exception('Failed to load history actions');
  }
}

class _HistoryPageState extends State<HistoryPage> {
  List<double> historyValues = [];
  List<DateTime> historyDates = [];
  List<String> historyActions = [];

  @override
  void initState() {
    super.initState();
    fetchHistoryValues().then((value) => setState(() {
          historyValues = value;
        }));
    fetchHistoryDates().then((value) => setState(() {
          historyDates = value;
        }));
    fetchHistoryActions().then((value) => setState(() {
          historyActions = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xffe7f6ff),
          title: const Text("History", style: TextStyle(fontSize: 20))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 30, top: 15),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Action   ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            const Text("Score",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
          ]),
        ),
        Expanded(child: _displayHistory())
      ]),
    );
  }

  Widget _displayHistory() {
    if(historyValues.length == 0 || historyDates.length == 0 || historyActions.length == 0){
      return Column();
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 5),
      itemCount: historyValues.length,
      itemBuilder: (BuildContext context, int index) {
        // Clothing clothing = clothes.elementAt(index);

        double historyValue =
            historyValues.elementAt(historyValues.length - 1 - index);
        DateTime historyDate =
            historyDates.elementAt(historyDates.length - 1 - index);
        String action =
            historyActions.elementAt(historyActions.length - 1 - index);
        String image = "images/recycling_symbol.png";
        if (action == "New item") {
          image = "images/shop.png";
        } else if (action == "Throw away") {
          image = "images/bin.png";
        } else if (action == "Give away") {
          image = "images/give_away_clothes.jpg";
        }

        Color scoreColor = Colors.green;
        if (historyValue < 0) {
          scoreColor = Color.fromRGBO(254, 96, 79, 1);
        }

        return Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('dd-MM-yyyy').format(historyDate))
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // BorderIcon(
                  //     height: 40,
                  //     width: 40,
                  //     bgColor: const Color(0xffffe8ec),
                  //     child: Image.asset(iconPath)),
                  // addHorizontalSpace(10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    BorderIcon(
                        height: 40,
                        width: 40,
                        bgColor: const Color(0xffffe8ec),
                        child: Image.asset(image)),
                    const SizedBox(width: 10)
                  ]),
                  Expanded(
                      child: ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(action,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ))),
                          const SizedBox(width: 100),
                          Row(
                            children: [
                              Text(
                                historyValue.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 16, color: scoreColor),
                              ),
                            ],
                          ),
                        ]),
                  )),
                ]),
                const SizedBox(height: 5),
                const Divider(color: Colors.black),
              ],
            ));
      },
    );
  }
}

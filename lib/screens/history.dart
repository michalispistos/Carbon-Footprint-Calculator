import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carbon_footprint_calculator/screens/your_score.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';

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

class _HistoryPageState extends State<HistoryPage> {
  List<double> historyValues = [];
  List<DateTime> historyDates = [];

  @override
  void initState() {
    super.initState();
    fetchHistoryValues().then((value) => setState(() {
          historyValues = value;
        }));
    fetchHistoryDates().then((value) => setState(() {
          historyDates = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xffe7f6ff),
            title: const Text("History")),
        body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: _displayClothes(),
    ));
  }

  Widget _displayClothes() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 5),
      itemCount: historyValues.length,
      itemBuilder: (BuildContext context, int index) {
        // Clothing clothing = clothes.elementAt(index);
        // String iconPath = "images/top.png";
        // if (clothing.type == "Bottoms") {
        //   iconPath = "images/bottom.png";
        // }
        // if (clothing.type == "Shoes") {
        //   iconPath = "images/shoes.png";
        // }
        double historyValue = historyValues.elementAt(historyValues.length -1 - index);
        DateTime historyDate = historyDates.elementAt(historyValues.length -1 - index);
        String action = "Recycle";
        return Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center,
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
                      Row(
                        children: [
                          Text(historyValue.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ]),
              )),
            ]),
            const SizedBox(height: 5),
            const Divider(color: Colors.black),
          ],
        );
      },
    );
  }
}

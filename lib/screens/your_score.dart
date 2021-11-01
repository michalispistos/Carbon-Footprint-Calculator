import 'dart:collection';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<Clothing> parseClothes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Clothing>((json) => Clothing.fromJson(json)).toList();
}

Future<List<Clothing>> fetchClothesInventory() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/your-clothes/1"));
  // final test = await http.post(
  //     Uri.parse("https://footprintcalculator.herokuapp.com/clothes"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'name': "Nike",
  //       'type': "Bottoms",
  //       'carbon_score': 1.4,
  //       'owner': 1
  //     }));
  // print(test.statusCode);
  if (response.statusCode == 200) {
    print(response.body);
    List<Clothing> result = parseClothes(response.body);
    print(result);
    return result;
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // List<Clothing> result = [];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load clothes list');
  }
}

class YourScore extends StatefulWidget {
  const YourScore({Key? key}) : super(key: key);

  @override
  _YourScoreState createState() => _YourScoreState();
}

class _YourScoreState extends State<YourScore> {
  late Future<List<Clothing>> clothesInventory;

  @override
  void initState() {
    super.initState();
    clothesInventory = fetchClothesInventory();
  }

  FutureBuilder calculateLifetimeCarbonScore() {
    return FutureBuilder<List<Clothing>>(
        future: clothesInventory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var themeData = Theme.of(context);
            double totalScore =
                snapshot.data!.fold(0, (prev, curr) => prev + curr.carbonScore);
            return Text(totalScore.toString(),
                style: themeData.textTheme.headline1!
                    .copyWith(color: Colors.green));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  FutureBuilder calculateLifetimeAverageCarbonScore() {
    return FutureBuilder<List<Clothing>>(
        future: clothesInventory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var themeData = Theme.of(context);
            double avgScore = snapshot.data!.fold(
                    0.0, (prev, curr) => (prev as double) + curr.carbonScore) /
                snapshot.data!.length;
            return Text(avgScore.toString(),
                style: themeData.textTheme.headline1!
                    .copyWith(color: Colors.green));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child:
      Column(children: [
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 3,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Column(children: [
              Text(
                "Lifetime total carbon score:",
                style: themeData.textTheme.headline2,
              ),
              calculateLifetimeCarbonScore()
            ]),
          )),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 3,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Column(children: [
              Text(
                "Lifetime average carbon score:",
                style: themeData.textTheme.headline2,
              ),
              calculateLifetimeAverageCarbonScore()
            ]),
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
        child: SizedBox(
          height: size.height / 2,
          child: FutureBuilder<List<Clothing>>(
              future: clothesInventory,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //TODO: Right now we only have the ability to generate a bar
                  //  chart for the full year. We should add functionality to do
                  //  it for a given month / week.
                  return BarChart(BarChartData(
                      barTouchData: BarTouchData(touchTooltipData:
                          BarTouchTooltipData(getTooltipItem:
                              (group, groupIndex, rod, rodIndex) {
                        String month = [
                          "January",
                          "February",
                          "March",
                          "April",
                          "May",
                          "June",
                          "July",
                          "August",
                          "September",
                          "October",
                          "November",
                          "December"
                        ][group.x.toInt() - 1];
                        String prefix = rodIndex == 0
                            ? "Total score for "
                            : "Average score for ";
                        return BarTooltipItem(
                            prefix + month + '\n',
                            themeData.textTheme.bodyText1!
                                .copyWith(color: Colors.white),
                            children: [
                              TextSpan(
                                  text: rod.y.toString(),
                                  style: themeData.textTheme.bodyText2!
                                      .copyWith(color: rod.colors[0]))
                            ]);
                      })),
                      barGroups:
                          buildBarGroupsFromClothingList(snapshot.data!, 3),
                      titlesData: FlTitlesData(
                        show: true,
                        // rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (context, value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            return [
                              "Jan",
                              "Feb",
                              "Mar",
                              "Apr",
                              "May",
                              "Jun",
                              "Jul",
                              "Aug",
                              "Sep",
                              "Oct",
                              "Nov",
                              "Dec"
                            ][value.toInt() - 1];
                          },
                        ),
                      )));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    ]));
  }
}

List<BarChartGroupData> buildBarGroupsFromClothingList(
    List<Clothing> clothesList, int viewBy) {
  List<BarChartGroupData> result = [];
  Map<dynamic, List<Clothing>> dateClothesMap = HashMap();
  switch (viewBy) {
    case 3:
      // Year View
      for (Clothing clothing in clothesList) {
        if (dateClothesMap.containsKey(clothing.dateTime.month)) {
          dateClothesMap[clothing.dateTime.month]!.add(clothing);
        } else {
          dateClothesMap[clothing.dateTime.month] = [clothing];
        }
      }

      for (var k in dateClothesMap.keys) {
        result.add(BarChartGroupData(x: k, barRods: [
          BarChartRodData(
              // Total carbon score for the month
              y: dateClothesMap[k]!
                  .fold(0, (prev, curr) => prev + curr.carbonScore)),
          BarChartRodData(
              // Average carbon score for the month
              y: dateClothesMap[k]!.fold(0.0,
                      (prev, curr) => (prev as double) + curr.carbonScore) /
                  dateClothesMap[k]!.length,
              colors: [Colors.orangeAccent]),
        ]));
      }
  }
  print(dateClothesMap);

  return result;
}

// class ClothesInventory {
//   final int userId;
//   final List<Clothing> clothingList;
//
//   ClothesInventory({required this.userId, required this.clothingList});
// }

class Clothing {
  final int id;
  final String name;
  final String type;
  final DateTime dateTime;
  final double carbonScore;

  Clothing(
      {required this.id,
      required this.name,
      required this.type,
      required this.dateTime,
      required this.carbonScore});

  factory Clothing.fromJson(Map<String, dynamic> json) {
    return Clothing(
      id: json['id'] as int,
      dateTime: DateTime.parse(json['date']),
      carbonScore: double.parse(json['carbon_score'].toString()),
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  @override
  String toString() {
    return "{id: $id, name: $name, date: $dateTime, carbon_score: $carbonScore";
  }
}

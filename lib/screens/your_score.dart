//   return FutureBuilder<double>(
//       future: carbonScoreInv,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           var themeData = Theme.of(context);
//           var totalScore =
//               snapshot.data!;
//           return Text(totalScore.toStringAsFixed(2),
//               style: themeData.textTheme.headline1!
//                   .copyWith(color: Colors.green));
//         } else if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         }
//
//         // By default, show a loading spinner.
//         return const CircularProgressIndicator();
//       });
//
// }

import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


const months = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

List<Clothing> parseClothes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Clothing>((json) => Clothing.fromJson(json)).toList();
}

Future<List<Clothing>> fetchClothesInventory() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/your-clothes/${globals.userid}"));
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
    // print(response.body);
    List<Clothing> result = parseClothes(response.body);
    // print(result);
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

// Future<double> fetchCarbonScore() async {
//   final response = await http.get(Uri.parse(
//       "https://footprintcalculator.herokuapp.com/users/carbon-score/${globals.userid}"));
//   if (response.statusCode == 200) {
//     return jsonDecode(response.body)["carbon_score"];
//   } else {
//     throw Exception('Failed to load clothes list');
//   }
// }

Future<List<double>> fetchHistoryValues() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/history-values/${globals.userid}"));
  if (response.statusCode == 200) {
    List<dynamic> list;
    if (jsonDecode(response.body)["history_values"] == null) {
      list = [];
    } else {
      list = jsonDecode(response.body)["history_values"];
    }

    return List<double>.from(list.map((x) => x.toDouble()).toList());
  } else {
    throw Exception('Failed to load history values');
  }
}

Future<List<List<double>>> fetchAllHistoryValues() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/all-history-values/all"));
  if (response.statusCode == 200) {
    List<dynamic> list;
    if (jsonDecode(response.body) == null) {
      list = [];
    } else {
      list = jsonDecode(response.body);
    }
    List<List<double>> res = list
        .map((val) => List<double>.from(
            ((val["history_values"]) == null ? [] : val["history_values"])
                .map((x) => x.toDouble())
                .toList()))
        .toList();
    return res;
  } else {
    throw Exception('Failed to load history values');
  }
}

Future<List<List<DateTime>>> fetchAllHistoryDates() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/all-history-dates/all"));
  if (response.statusCode == 200) {
    List<dynamic> allHistoryDates;
    if (jsonDecode(response.body) == null) {
      allHistoryDates = [];
    } else {
      allHistoryDates = jsonDecode(response.body);
    }
    List<dynamic> list =
        allHistoryDates.map((val) => val["history_dates"]).toList();
    List<List<DateTime>> res = list.map((val) => parseDate(val)).toList();
    return res;
  } else {
    throw Exception('Failed to load history values');
  }
}

List<DateTime> parseDate(val) {
  if (val == null || val.length == 0) {
    return <DateTime>[];
  }

  List<DateTime> res = <DateTime>[];
  for (dynamic date in val) {
    res.add(DateTime.parse(date.toString()));
  }
  return res;
}

Future<List<DateTime>> fetchHistoryDates() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/history-dates/${globals.userid}"));
  if (response.statusCode == 200) {
    List<dynamic> list;
    if (jsonDecode(response.body)["history_dates"] == null) {
      list = [];
    } else {
      list = jsonDecode(response.body)["history_dates"];
    }
    if (list.length == 0) {
      return <DateTime>[];
    }
    List<DateTime> res =
        list.map((val) => DateTime.parse(val.toString())).toList();
    return res;
  } else {
    throw Exception('Failed to load history dates');
  }
}

FutureBuilder calculateNewUsersCarbonScore(double add, bool decrease) {
  return FutureBuilder<List<double>>(
      future: fetchHistoryValues() as Future<List<double>>,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var themeData = Theme.of(context);
          double totalScore = snapshot.data!
              .fold(0, (prev, curr) => (prev as double) + (curr as double));
          return Text((totalScore + add).toStringAsFixed(2),
              style: themeData.textTheme.headline3!.copyWith(
                  color: decrease
                      ? Colors.green
                      : Color.fromRGBO(254, 96, 79, 1)));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      });
}

class YourScore extends StatefulWidget {
  const YourScore({Key? key}) : super(key: key);

  @override
  _YourScoreState createState() => _YourScoreState();
}

class _YourScoreState extends State<YourScore> {
  late Future<List<Clothing>> clothesInventory;
  late Future<List<double>> historyValuesInventory;
  late Future<List<DateTime>> historyDatesInventory;
  late Future<List<List<DateTime>>> allHistoryDatesInventory;
  late Future<List<List<double>>> allHistoryValuesInventory;
  late int viewBy;
  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    //By default, view by year
    viewBy = 3;
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;
    clothesInventory = fetchClothesInventory();
    historyDatesInventory = fetchHistoryDates();
    historyValuesInventory = fetchHistoryValues();
    allHistoryDatesInventory = fetchAllHistoryDates();
    allHistoryValuesInventory = fetchAllHistoryValues();
  }

  // FutureBuilder calculateLifetimeCarbonScore() {
  //   return FutureBuilder<List<double>>(
  //       future: historyValuesInventory,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           var themeData = Theme.of(context);
  //           double totalScore =
  //           snapshot.data!.fold(0, (prev, curr) => prev + curr);
  //           return Text(totalScore.toStringAsFixed(2),
  //               style: themeData.textTheme.headline3!
  //                   .copyWith(color: Colors.green));
  //         } else if (snapshot.hasError) {
  //           return Text('${snapshot.error}');
  //         }
  //
  //         // By default, show a loading spinner.
  //         return const CircularProgressIndicator();
  //       });
  // }

  FutureBuilder calculateLifetimeAverageCarbonScore() {
    return FutureBuilder<List<Clothing>>(
        future: clothesInventory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var themeData = Theme.of(context);
            double avgScore = snapshot.data!
                .fold(0.0, (prev, curr) => (prev as double) + curr.carbonScore);
            if (avgScore != 0) {
              avgScore = avgScore / snapshot.data!.length;
            }
            return Text(avgScore.toStringAsFixed(2),
                style: themeData.textTheme.headline3!
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
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Column(children: [
                      Text(
                        "Lifetime total carbon score:",
                        style: themeData.textTheme.headline6!
                            .copyWith(height: 1.1),
                        textAlign: TextAlign.center,
                      ),
                      calculateNewUsersCarbonScore(0, true)
                    ]),
                  )),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Column(children: [
                      Text(
                        "Lifetime average score per item:",
                        style: themeData.textTheme.headline6!
                            .copyWith(height: 1.1),
                        textAlign: TextAlign.center,
                      ),
                      calculateLifetimeAverageCarbonScore()
                    ]),
                  )),
            )
          ],
        ),
      ),
      addVerticalSpace(10),
      Column(children: [
        Text("Viewing data for", style: themeData.textTheme.headline6),
        Text(currentGraphPeriod(), style: themeData.textTheme.headline5)
      ]),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: SizedBox(
          height: size.height / 2,
          child: FutureBuilder(
              future: Future.wait([
                historyValuesInventory,
                historyDatesInventory,
                clothesInventory,
                allHistoryValuesInventory,
                allHistoryDatesInventory
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  //TODO: Right now we only have the ability to generate a bar
                  //  chart for the full year. We should add functionality to do
                  //  it for a given month / week.
                  return BarChart(BarChartData(
                      barTouchData: BarTouchData(touchTooltipData:
                          BarTouchTooltipData(getTooltipItem:
                              (group, groupIndex, rod, rodIndex) {
                        String period = "";
                        switch (viewBy) {
                          case 2:
                            int value = group.x.toInt();
                            String suffix = value % 10 == 1
                                ? "st"
                                : value % 10 == 2
                                    ? "nd"
                                    : value % 10 == 3
                                        ? "rd"
                                        : "th";
                            period = value.toString() + suffix;
                            break;
                          case 3:
                            period = months[group.x.toInt() - 1];
                            break;
                        }

                        String prefix = rodIndex == 0
                            ? "Your Total score for "
                            : (rodIndex == 1
                                ? "Your Average score per item for "
                                : "Average score amongst users for ");
                        return BarTooltipItem(
                            prefix +
                                period +
                                ' ' +
                                (viewBy == 2 ? months[selectedMonth - 1] : '') +
                                '\n',
                            themeData.textTheme.bodyText1!
                                .copyWith(color: Colors.white),
                            children: [
                              TextSpan(
                                  text: rod.y.toString(),
                                  style: themeData.textTheme.headline6!
                                      .copyWith(color: Colors.white))
                            ]);
                      })),
                      barGroups: buildBarGroupsFromClothingList(
                          snapshot.data![0],
                          snapshot.data![1],
                          snapshot.data![2],
                          snapshot.data![3],
                          snapshot.data![4],
                          viewBy,
                          month: selectedMonth,
                          year: selectedYear),
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
                              switch (viewBy) {
                                case 2:
                                  // Month view
                                  String suffix = value % 10 == 1
                                      ? "st"
                                      : value % 10 == 2
                                          ? "nd"
                                          : value % 10 == 3
                                              ? "rd"
                                              : "th";
                                  return value.toInt().toString() + suffix;
                                case 3:
                                  // Year view
                                  return months[value.toInt() - 1]
                                      .substring(0, 3);
                                default:
                                  return value.toString();
                              }
                            }),
                      )));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          color: const Color(0xfffffaca),
          onPressed: () {
            setState(() {
              viewBy = 2;
            });
          },
          child: const Text('View by month',
              style: TextStyle(
                fontSize: 17,
              )),
        ),
        addHorizontalSpace(10),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          color: const Color(0xfffffaca),
          onPressed: () {
            setState(() {
              viewBy = 3;
            });
          },
          child: const Text('View by year',
              style: TextStyle(
                fontSize: 17,
              )),
        ),
      ]),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(
            "Your score is measured in kg of CO2 produced.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(
            "The average passenger vehicle emits about 0.65 kg of CO2 per km.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )),
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Text("Information source: "),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: InkWell(
              child: const Text(
                "https://www.epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => launch(
                  'https://www.epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle'))),
    ]));
  }

  String currentGraphPeriod() {
    switch (viewBy) {
      case 2:
        return months[selectedMonth - 1] + ' ' + selectedYear.toString();
      case 3:
        return selectedYear.toString();
      default:
        return "Invalid Date";
    }
  }
}

List<BarChartGroupData> buildBarGroupsFromClothingList(
    List<double> historyValues,
    List<DateTime> historyDates,
    List<Clothing> clothesList,
    List<List<double>> allHistoryValues,
    List<List<DateTime>> allHistoryDates,
    int viewBy,
    {int month = -1,
    int year = -1}) {
  List<BarChartGroupData> result = [];
  Map<dynamic, List<Clothing>> dateClothesMap = HashMap();
  Map<dynamic, List<double>> dateValuesMap = HashMap();
  Map<dynamic, List<double>> averageDateValuesMap = HashMap();
  switch (viewBy) {
    case 2:
      // Month View
      print(allHistoryValues);
      for (var i = 0; i < allHistoryValues.length; i++) {
        for (var j = 0; j < allHistoryValues[i].length; j++) {
          DateTime date = allHistoryDates[i][j];
          double value = allHistoryValues[i][j];
          if (date.month == month && date.year == year) {
            if (averageDateValuesMap.containsKey(date.day)) {
              averageDateValuesMap[date.day]!.add(value);
            } else {
              averageDateValuesMap[date.day] = [value];
            }
          }
        }
      }

      for (Clothing clothing in clothesList) {
        if (clothing.dateTime.month == month &&
            clothing.dateTime.year == year) {
          if (dateClothesMap.containsKey(clothing.dateTime.day)) {
            dateClothesMap[clothing.dateTime.day]!.add(clothing);
          } else {
            dateClothesMap[clothing.dateTime.day] = [clothing];
          }
        }
      }

      for (var i = 0; i < historyValues.length; i++) {
        DateTime date = historyDates[i];
        double value = historyValues[i];
        if (date.month == month && date.year == year) {
          if (dateValuesMap.containsKey(date.day)) {
            dateValuesMap[date.day]!.add(value);
          } else {
            dateValuesMap[date.day] = [value];
          }
        }
      }
      break;
    case 3:
      // Year View

      for (Clothing clothing in clothesList) {
        if (dateClothesMap.containsKey(clothing.dateTime.month)) {
          dateClothesMap[clothing.dateTime.month]!.add(clothing);
        } else {
          dateClothesMap[clothing.dateTime.month] = [clothing];
        }
      }

      for (var i = 0; i < historyValues.length; i++) {
        DateTime date = historyDates[i];
        double value = historyValues[i];
        if (dateValuesMap.containsKey(date.month)) {
          dateValuesMap[date.month]!.add(value);
        } else {
          dateValuesMap[date.month] = [value];
        }
      }

      for (var i = 0; i < allHistoryValues.length; i++) {
        for (var j = 0; j < allHistoryValues[i].length; j++) {
          DateTime date = allHistoryDates[i][j];
          double value = allHistoryValues[i][j];
          if (averageDateValuesMap.containsKey(date.month)) {
            averageDateValuesMap[date.month]!.add(value);
          } else {
            averageDateValuesMap[date.month] = [value];
          }
        }
      }
      break;
  }

  for (var k in averageDateValuesMap.keys) {
    // Total carbon score for the month
    var averageCarbonFromUsersBar = BarChartRodData(
        y: averageDateValuesMap[k]!
                .fold(0.0, (prev, curr) => (prev as double) + curr) /
            allHistoryValues.length,
        colors: [Color(0xfffb6f92)]);

    var totalCarbonBar = BarChartRodData(y: 0);
    var averageCarbonPerItemBar = BarChartRodData(
        // Average carbon score for the month per item
        y: 0,
        colors: [Colors.orangeAccent]);
    if (dateValuesMap.keys.contains(k)) {
      totalCarbonBar = BarChartRodData(
          y: dateValuesMap[k]!.fold(0, (prev, curr) => prev + curr));

      if (dateClothesMap.keys.contains(k)) {
        averageCarbonPerItemBar = BarChartRodData(
            // Average carbon score for the month per item
            y: dateClothesMap[k]!.fold(
                    0.0, (prev, curr) => (prev as double) + curr.carbonScore) /
                dateClothesMap[k]!.length,
            colors: [Colors.orangeAccent]);
      }
    }

    result.add(BarChartGroupData(x: k, barRods: [
      totalCarbonBar,
      averageCarbonPerItemBar,
      averageCarbonFromUsersBar
    ]));
  }

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

import 'dart:convert';
import 'dart:math';

import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:achievement_view/achievement_view.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:carbon_footprint_calculator/screens/your_score.dart';


List<Achievement> parseAchievements(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Achievement>((json) => Achievement.fromJson(json)).toList();
}

Future<List<Achievement>> fetchAchievements() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/achievements/"));

  if (response.statusCode == 200) {
    // print(response.body);
    List<Achievement> result = parseAchievements(response.body);
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

Future<List<int>> fetchMyAchievements() async {
  print(globals.userid);
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/achievements/${globals.userid}"));
  if (response.statusCode == 200) {
    List<dynamic> list;
    if (jsonDecode(response.body)["achievements"] == null) {
      list = [];
    } else {
      list = jsonDecode(response.body)["achievements"];
    }

    return List<int>.from(list.map((x) => x.toInt()).toList());
  } else {
    throw Exception('Failed to load myAchievements');
  }
}

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  List<Achievement> achievements = [];
  List<int> myAchievements = [];
  int clothingItems = 0;
  int recyclingItems = 0;
  int gaveAwayItems = 0;

  @override
  void initState() {
    super.initState();
    //By default, view by year
    fetchAchievements().then((value)=>
      setState(() {
        achievements = value;
      }),
    );
    fetchMyAchievements().then((value) =>
        setState(() {
          myAchievements = value;
        }),
    );
    fetchClothesInventory().then((value) =>
        setState(() {
          clothingItems = value.length;
        }),
    );
    // fetchHistoryActions().then((value) =>
    // {
    //   int count = 0,
    //
    //   setState(() {
    //     recyclingItems = value.length;
    //   }),
    // }
    // );
    // fetchMyAchievements().then((value) =>
    //     setState(() {
    //       myAchievements = value;
    //     }),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xffe7f6ff),
            title: const Text("Achievements",style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ))),
        body: _displayAchievements());
  }

  Widget _displayAchievements() {
    orderAchievements(achievements);
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
      itemCount: achievements.length,
      itemBuilder: (BuildContext context, int index) {
        Achievement achievement = achievements.elementAt(index);

        Color LOCKED_TEXT_COLOR = Colors.grey.shade600;
        Color LOCKED_BG_COLOR = Colors.grey.shade50;
        Icon LOCK_ICON = Icon(Icons.lock, color: Colors.grey);

        Image MEDAL_IMAGE = Image.asset("images/medal.png");
        Color MEDAL_BG_COLOR = Color(0xffffe8ec);
        Color NORMAL_TEXT_COLOR = Colors.black;

        Color border_color = LOCKED_BG_COLOR;
        Widget achievement_icon = LOCK_ICON;
        Color text_color = LOCKED_TEXT_COLOR;

        if (myAchievements.contains(achievement.id)){
          border_color = MEDAL_BG_COLOR;
          achievement_icon = MEDAL_IMAGE;
          text_color = NORMAL_TEXT_COLOR;
        }

        return Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children:[
              BorderIcon(
                  height: 42,
                  width: 42,
                  bgColor: border_color,
                  child: achievement_icon),
              addHorizontalSpace(15),
              Container(
                height:100,
                width: 225,
              child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                addVerticalSpace(22),
                Flexible(
                    child: Text(achievement.name,
                        style: TextStyle(
                          fontSize: 17,
                          color: text_color,
                        ))),
                Flexible(
                  child: Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ]))]),
                  addVerticalSpace(22),
                  Container(
                    height: 100,
                    child: Align(
                        alignment:Alignment(0,1),
                        child:
                  Text("${min(achievement.tasks_num, clothingItems)}/${achievement.tasks_num}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      )
                  ))),
            ]),

            LinearProgressIndicator(
              value: min(achievement.tasks_num, clothingItems)/achievement.tasks_num,
              semanticsLabel: 'Linear progress indicator',
              color: Color(0xfffffd700),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 5),
            const Divider(color: Colors.black),
          ],
        );
      },
    );
  }

  void show(BuildContext context) {
    // AchievementView(
    //   context,
    //   title: "Yeaaah!",
    //   subTitle: "Training completed successfully! ",
    //   isCircle: isCircle,
    //   listener: (status) {
    //     print(status);
    //   },
    // )..show();
    // }
  }

  void orderAchievements(List<Achievement> achievements) {
    int index = 0;
    for(Achievement achievement in achievements){
      if(myAchievements.contains(achievement.id)){
        achievements.remove(achievement);
        achievements.insert(index,achievement);
        index++;
      }
    }

  }
}

class Achievement {
  String name;
  String description;
  int id;
  int tasks_num;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.tasks_num,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      tasks_num: json['tasks_num'] as int,
    );
  }
}

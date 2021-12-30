import 'dart:convert';
import 'dart:math';

import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'package:carbon_footprint_calculator/screens/your_score.dart';
import 'package:achievement_view/achievement_view.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

List<Achievement> parseAchievements(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Achievement>((json) => Achievement.fromJson(json)).toList();
}

Future<List<Achievement>> fetchAchievements() async {
  final response = await http.get(
      Uri.parse("https://footprintcalculator.herokuapp.com/achievements/"));

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

Future<List<Achievement>> fetchAchievementsType(String type) async {
  final response = await http.get(
      Uri.parse("https://footprintcalculator.herokuapp.com/achievements/type/$type"));

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
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/users/completed-achievements/${globals.userid}"));

  if (response.statusCode == 200) {
    List<dynamic> list;
    if (jsonDecode(response.body)["completed_achievements"] == null) {
      list = [];
    } else {
      list = jsonDecode(response.body)["completed_achievements"];
    }
    return List<int>.from(list.map((x) => x.toInt()).toList());
  } else {
    throw Exception('Failed to load myAchievements');
  }
}

Future<int> fetchProgress(int achievement_id) async{
  final response = await http.get(
      Uri.parse("https://footprintcalculator.herokuapp.com/user-achievement/achievement-progress/${globals.userid}/$achievement_id"));
  if (response.statusCode == 200) {
    int progress = jsonDecode(response.body)["progress"];
    return progress;
  } else {
    throw Exception('Failed to load progress');
  }

}

Future<List<dynamic>> fetchProgresses() async {
  final response = await http.get(Uri.parse(
      "https://footprintcalculator.herokuapp.com/user-achievement/achievements-progress/${globals.userid}"));
  if (response.statusCode == 200) {
    List<dynamic> list;
    if (jsonDecode(response.body) == null) {
      list = [];
    } else {
      list = jsonDecode(response.body);
    }
    return list;
  } else {
    throw Exception('Failed to load history values');
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
  List<dynamic> progresses = [];

  @override
  void initState() {
    super.initState();
    //By default, view by year
    fetchAchievements().then(
      (value) => setState(() {
        achievements = value;
      }),
    );
    fetchMyAchievements().then(
      (value) => setState(() {
        myAchievements = value;
      }),
    );
    fetchProgresses().then(
      (value) => setState((){
        progresses = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xffe7f6ff),
            title: const Text("Achievements",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ))),
        body: _displayAchievements());
  }

  Widget _displayAchievements(){
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

        if (myAchievements.contains(achievement.id)) {
          border_color = MEDAL_BG_COLOR;
          achievement_icon = MEDAL_IMAGE;
          text_color = NORMAL_TEXT_COLOR;
        }

        int progress = 0;
        for(dynamic prog in progresses){
          if(prog["achievement_id"] == achievement.id){
            progress = prog["progress"];
            break;
          }
        }


        return Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                BorderIcon(
                    height: 42,
                    width: 42,
                    bgColor: border_color,
                    child: achievement_icon),
                addHorizontalSpace(15),
                Container(
                    height: 100,
                    width: 215,
                    child: Column(
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
                            child:
                            Text(
                              achievement.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ]))
              ]),
              // addVerticalSpace(22),
              Column(
                children:[
                     IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () async {
                          final ByteData bytes = await rootBundle.load("images/medal.png");
                          final Uint8List list = bytes.buffer.asUint8List();

                          final tempDir = await getTemporaryDirectory();
                          final file = await new File('${tempDir.path}/image.jpg').create();
                          file.writeAsBytesSync(list);
                          Share.shareFiles(['${file.path}'],text:
                              achievement.name + " - " +  achievement.description,
                          );
                          setState((){});
                        },

                      ),
              Container(
                  height: 40,
                  child: Align(
                      alignment: Alignment(0, 1),
                      child: Text(
                          "$progress/${achievement.tasks_num}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )))),
            ])]),
            LinearProgressIndicator(
              value: progress /
                  achievement.tasks_num,
              semanticsLabel: 'Linear progress indicator',
              color: const Color(0xfffffd700),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 5),
            const Divider(color: Colors.black),
          ],
        );
      },
    );
  }

  void orderAchievements(List<Achievement> achievements) {
    int index = 0;
    for (Achievement achievement in achievements) {
      if (myAchievements.contains(achievement.id)) {
        achievements.remove(achievement);
        achievements.insert(index, achievement);
        index++;
      }
    }

  }



}

void showAchievement(BuildContext context, Achievement achievement) {
  AchievementView(
      context,
      title: achievement.name,
      subTitle: achievement.description,
      color: Colors.green.shade500,
      textStyleTitle: TextStyle(fontSize: 16),
      textStyleSubTitle: TextStyle(fontSize: 12),
      duration: Duration(seconds: 2),
      borderRadius: 10, listener: (status) {
    //print(status);
  }).show();
}

checkUpdateAchievements(BuildContext context, String type) async {
  List<int> completed_achievements = [];
   await fetchMyAchievements().then(
        (value) => completed_achievements = value,
  );
  List<Achievement> achievements = [];
  if(type == "recycle") {
    await fetchAchievementsType("recycle").then(
          (value) => achievements = value,
    );
  }else if(type == "new_item"){
    await fetchAchievementsType("new_item").then(
          (value) => achievements = value,
    );

  }else {
    await fetchAchievementsType("give_away").then(
          (value) => achievements = value,
    );
  }
  for (Achievement achievement in achievements) {
    int achievement_id = achievement.id;
    if (completed_achievements.contains(achievement_id)) {
      continue;
    }
    await http.put(
        Uri.parse("https://footprintcalculator.herokuapp.com/user-achievement/achievement-progress/${globals.userid}/$achievement_id"));
    int progress = 0;
    await fetchProgress(achievement.id).then(
            (value) =>
            progress = value
          );

    if (progress == achievement.tasks_num) {
      showAchievement(context, achievement);
      await http.post(
          Uri.parse("https://footprintcalculator.herokuapp.com/users/add-completed-achievement/${globals.userid}/$achievement_id"));
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

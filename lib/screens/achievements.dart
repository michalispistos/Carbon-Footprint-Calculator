import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xffe7f6ff),title: const Text("Achievements")),
        body: const Center(child: Icon(Icons.ac_unit)));
  }
}

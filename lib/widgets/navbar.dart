import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavBar extends StatelessWidget {
  const NavBar();

  // Your Clothes, Best Brands, Your Score, Check Item
  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.20 - 50;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
        ["Your Clothes", "Best Brands", "Your Score", "Check Item"]
            .map((section) => ChoiceOption(text: section)).toList(),
      )
    );
  }
}

class ChoiceOption extends StatelessWidget {

  final String text;

  const ChoiceOption({Key? key,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: CustomTheme.COLOR_GREY.withAlpha(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      margin: const EdgeInsets.only(left: 25),
      child: Text(text, style: themeData.textTheme.headline5),
    );
  }
}

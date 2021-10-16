import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget inputSections = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonRow(color, Icons.call, 'CALL'),
        _buildButtonRow(color, Icons.near_me, 'ROUTE'),
        _buildButtonRow(color, Icons.share, 'SHARE'),
      ],
    );

    return MaterialApp(
      theme: CustomTheme.lightTheme,
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Carbon Footprint Calculator'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/coatrack.png'),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("Type of product")]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("Weight of product")]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Expanded(child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Weight in kg"),
              ))
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("Material")]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: 350,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Calculate carbon score'),
                  ))
            ]),
          ],
        ),
      ),
    );
  }

  Row _buildButtonRow(Color color, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

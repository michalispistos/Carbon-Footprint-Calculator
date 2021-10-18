import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/brands_grid.dart';
import 'package:carbon_footprint_calculator/widgets/navbar.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Carbon Footprint Calculator",
    theme: CustomTheme.lightTheme,
    home: const BrandPage()));

class BrandPage extends StatelessWidget {
  const BrandPage({Key? key}) : super(key: key);
  static const NavBar navBar = NavBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Green Brands"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          CustomPaint(size: Size.infinite, painter: CircleBackgroundPainter()),
          Column(children: const <Widget>[navBar, BrandsGrid()])
        ],
      ),
    );
  }
}

class CircleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Offset sets each circle's center
    canvas.drawCircle(Offset(size.width - 40, 20), 150,
        Paint()..color = const Color(0xffffe3d3));
    canvas.drawCircle(Offset(size.width / 2, size.height), 300,
        Paint()..color = const Color(0xffe7f6ff));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

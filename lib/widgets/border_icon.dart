import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:flutter/material.dart';

class BorderIcon extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color bgColor;
  final double width, height;

  const BorderIcon(
      {Key? key,
      this.padding = const EdgeInsets.all(8),
      this.width = 0,
      this.height = 0,
      required this.child,
      this.bgColor = CustomTheme.COLOR_WHITE})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
                color: CustomTheme.COLOR_GREY.withAlpha(40), width: 2)),
        padding: padding,
        child: Center(child: child));
  }
}

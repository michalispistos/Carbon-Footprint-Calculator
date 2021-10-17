import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/utils/carbon_calculator.dart';

class CarbonFootprint {
  CarbonCalculator calculator;

  CarbonFootprint({required this.calculator});

  double getFootprint(Item item) {
    return calculator.calculateCarbon(item);
  }
}
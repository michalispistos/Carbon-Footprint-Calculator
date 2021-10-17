import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/utils/carbon_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Calculation: 28 * 48 * 0.001
  test('Carbon of a 100% cotton item of weight 48g should be 1.344', () {
    final carbonCalculator = DefaultCarbonCalculator();

    double carbon = carbonCalculator.calculateCarbon(Item({"Cotton" : 1}, "", 48));

    expect(carbon, 1.344);
  });
}
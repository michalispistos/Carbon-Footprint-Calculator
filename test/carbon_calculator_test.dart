import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/utils/carbon_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final carbonCalculator = DefaultCarbonCalculator();
  // Calculation: 28 * 48 * 0.001
  test('Carbon of a 100% cotton item of weight 48g should be 1.344', () {
    double carbon = carbonCalculator.calculateCarbon(Item({"Cotton" : 1}, "", 48));

    expect(carbon, 1.344);
  });

  test('Carbon of a 50% cotton item, 50% acrylic item of weight 48g should be 1.584', () {
    double carbon = carbonCalculator.calculateCarbon(Item({"Cotton" : 0.5, "Acrylic" : 0.5}, "", 48));

    expect(carbon, 1.584);
  });

  test('Item with an unrecognised material throws an exception', () {

    expect(() => carbonCalculator.calculateCarbon(Item({"not a material" : 0.5, "Acrylic" : 0.5}, "", 48)),
      throwsA(predicate((e) => e is ArgumentError && e.message == "Item contains an unknown material.")));
  });

}
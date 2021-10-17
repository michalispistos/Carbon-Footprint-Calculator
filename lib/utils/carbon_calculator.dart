import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/utils/materials_impact.dart';

abstract class CarbonCalculator {
  double calculateCarbon(Item item);
}

class DefaultCarbonCalculator implements CarbonCalculator {
  Map<String, int> materialsImpact = MaterialsImpact.materialsImpact;

  @override
  double calculateCarbon(Item item) {
    double result = 0;

    for (String material in item.materials.keys) {
      // Should never be null
      double percentage = item.materials[material]!;

      if (!materialsImpact.containsKey(material)) {
        throw Exception("Item contains an unknown material.");
      }

      result += materialsImpact[material]! * percentage * item.weight * 0.001;
    }

    return result;
  }
}

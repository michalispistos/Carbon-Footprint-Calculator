import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/utils/test_utils.dart';

void main() {
  group('Testing brands routes', () {
    test('Get top picks route valid', () async {
      int status = await doesGetHTTPRequestSucceed(
          'https://footprintcalculator.herokuapp.com/brands/top-picks');
      expect(status, 200);
    });
  });

}
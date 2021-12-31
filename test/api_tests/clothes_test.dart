import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/utils/test_utils.dart';

void main() {
  group('Testing clothes routes', () {
    test('Get clothes item route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/clothes/1/');
      expect(status, 200);
    });
  });
}
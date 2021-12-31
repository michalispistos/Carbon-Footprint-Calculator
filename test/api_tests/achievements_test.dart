import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/utils/test_utils.dart';

void main() {
  group('Testing achievements routes', () {
    test('Get achievements route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/achievements');
      expect(status, 200);
    });
    test('Get achievements by type route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/achievements/type/new_item');
      expect(status, 200);
    });
    test('Get achievement by id route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/achievements/1');
      expect(status, 200);
    });
  });

}
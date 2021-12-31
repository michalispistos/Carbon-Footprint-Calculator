import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/utils/test_utils.dart';

void main() {
  group('Testing user-achievement routes', () {
    test('Get user achievement progress by user id route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/user-achievement/achievements-progress/1');
      expect(status, 200);
    });
    test('Get user achievement progress by user id and achievement id route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/user-achievement/achievement-progress/1/1');
      expect(status, 200);
    });

  });

}
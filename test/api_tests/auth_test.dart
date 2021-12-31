import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/utils/test_utils.dart';

void main() {
  group('Testing auth routes', () {
    test('Get user-id route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/auth/get-id');
      expect(status, 200);
    });
  });

}
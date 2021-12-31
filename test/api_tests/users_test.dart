import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/utils/test_utils.dart';

void main() {
  group('Testing get routes', () {
    test('Get user route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/1');
      expect(status, 200);
    });
    test('Get a user\'s clothes route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/your-clothes/1');
      expect(status, 200);
    });
    test('Get a user\'s history values route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/history-values/1');
      expect(status, 200);
    });
    test('Get a user\'s history dates route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/history-dates/1');
      expect(status, 200);
    });
    test('Get a user\'s history actions route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/history-actions/1');
      expect(status, 200);
    });
    test('Get a user\'s carbon score route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/carbon-score/1');
      expect(status, 200);
    });
    test('Get all history values route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/all-history-values/all');
      expect(status, 200);
    });
    test('Get all history dates route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/all-history-dates/all');
      expect(status, 200);
    });
    test('Get a user\'s completed achievements route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/completed-achievements/1');
      expect(status, 200);
    });
    test('Get a user\'s created date route valid', () async {
      int status = await doesGetHTTPRequestSucceed('https://footprintcalculator.herokuapp.com/users/created-date/1');
      expect(status, 200);
    });

  });

}
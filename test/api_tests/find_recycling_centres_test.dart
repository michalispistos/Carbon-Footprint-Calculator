import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Invalid postcode throws error', () async {
    final response = await http.get(Uri.parse(
        'https://rl.recyclenow.com/widget/www.recyclenow.com/locations/invalidpostcode?limit=30&radius=25&materials[]=57&materials[]=58&materials[]=59'));
    expect(response.statusCode, (500 | 404));
  });
  test('Valid postcode doesn\'t throw error', () async {
    final response = await http.get(Uri.parse(
        'https://rl.recyclenow.com/widget/www.recyclenow.com/locations/SW61NJ?limit=30&radius=25&materials[]=57&materials[]=58&materials[]=59'));
    expect(response.statusCode, 200);
  });
}



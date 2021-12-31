import 'package:http/http.dart' as http;

Future<int> doesGetHTTPRequestSucceed(String url) async {
  final response = await http.get(
      Uri.parse(url)).timeout(
    const Duration(seconds: 5),
    onTimeout: () {
      // Time has run out, do what you wanted to do.
      return http.Response('Error', 500);
    },
  );
  return response.statusCode;

}


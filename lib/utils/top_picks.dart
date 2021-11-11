import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

List<TopPicks> parseTopPicks(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<TopPicks>((json) => TopPicks.fromJson(json)).toList();
}

// Future<List<TopPicks>> fetchTopPicks() async {
//   final response = await http.get(
//       Uri.parse('https://footprintcalculator.herokuapp.com/brands/top-picks'));
//
//   return parseTopPicks(response.body);
// }

Future<List<TopPicks>> fetchTopPicks() async {
  String fileName = "CacheTopPicks.json";
  var cacheDir = await getTemporaryDirectory();

  if (await File(cacheDir.path + "/" + fileName).exists()) {
    print("Loading from cache"+ cacheDir.path);
    var jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();
    return parseTopPicks(jsonData);
  }
  print("Loading from API");
  final response = await http.get(
      Uri.parse('https://footprintcalculator.herokuapp.com/brands/top-picks'));
  if (response.statusCode == 200) {
    var jsonResponse = response.body;
    List<TopPicks> res = parseTopPicks(jsonResponse);
    var tempDir = await getTemporaryDirectory();
    File file = File(tempDir.path + "/" + fileName);
    file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);
    return res;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load BrandInfo');
  }
}

class TopPicks {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final String ethicalLabel;
  final int ethicalRating;
  final int price;

  TopPicks(
      {required this.id,
      required this.name,
      required this.slug,
      required this.imageUrl,
      required this.ethicalLabel,
      required this.ethicalRating,
      required this.price});

  factory TopPicks.fromJson(Map<String, dynamic> json) {
    return TopPicks(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['image'] as String,
      ethicalLabel: json['image'] as String,
      ethicalRating: json['ethicalRating'] as int,
      price: json['price'] as int,
    );
  }
}

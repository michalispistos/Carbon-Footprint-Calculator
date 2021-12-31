import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:carbon_footprint_calculator/utils/custom_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
    DateTime timeCreated = File(cacheDir.path + "/" + fileName).lastModifiedSync();
    if (DateTime.now().isAfter(timeCreated.add(const Duration(days: 7)))) {
      print("Been a week now im clearing the cache and getting data again");
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
    } else {
      print("Loading from cache");
      var jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();
      return parseTopPicks(jsonData);
    }
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

// Future<List<TopPicks>> fetchTopPicks() async {
//   print("here");
//   var file = await DefaultCacheManager().getSingleFile('https://footprintcalculator.herokuapp.com/brands/top-picks');
//   if (await file.exists()) {
//     print("LOADING TOP PICKS");
//     var res = await file.readAsString();
//     return parseTopPicks(res);
//   } else {
//     print("F");
//     throw Exception('Failed to load BrandInfo');
//   }
// }

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
      ethicalLabel: json['ethicalLabel'] as String,
      ethicalRating: json['ethicalRating'] as int,
      price: json['price'] as int,
    );
  }
}

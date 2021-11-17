import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Future<BrandInfo> fetchBrand(String id) async {
//   final response = await http.get(Uri.parse(
//       'https://footprintcalculator.herokuapp.com/brands/top-picks/' + id));
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return BrandInfo.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load BrandInfo');
//   }
// }

Future<BrandInfo> fetchBrand(String id) async {
  String fileName = "CacheBrand" + id + ".json";
  var cacheDir = await getTemporaryDirectory();
  if (await File(cacheDir.path + "/" + fileName).exists()) {
    DateTime timeCreated = File(cacheDir.path + "/" + fileName).lastModifiedSync();
    if (DateTime.now().isAfter(timeCreated.add(const Duration(days: 7)))) {
      print("Been a week now im clearing the cache and getting data again");
      final response = await http.get(
          Uri.parse('https://footprintcalculator.herokuapp.com/brands/top-picks/' + id));
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        BrandInfo res = BrandInfo.fromJson(jsonDecode(jsonResponse));
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
      return BrandInfo.fromJson(jsonDecode(jsonData));
    }
  }
  print("Loading from API");
  final response = await http.get(
      Uri.parse('https://footprintcalculator.herokuapp.com/brands/top-picks/' + id));
  if (response.statusCode == 200) {
    var jsonResponse = response.body;
    BrandInfo res = BrandInfo.fromJson(jsonDecode(jsonResponse));
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

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
  // Activewear, T-Shirts, Knitwear, Dresses, Tops & Blouses, Sweaters
// Shirts, Dresses
}

class Location {
  final String code;
  final String name;

  Location({
    required this.code,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      code: json['code'],
      name: json['name'],
    );
  }

}

class BrandInfo {
  final String name;
  final String ethicalInfo1;
  final String ethicalInfo2;
  final List<Category> categories;
  final String logoUrl;
  final int priceRating;
  final int ethicalRating;
  final String websiteUrl;
  final String imageUrl;
  final List<Location> location;

  BrandInfo({
    required this.name,
    required this.ethicalInfo1,
    required this.ethicalInfo2,
    required this.categories,
    required this.logoUrl,
    required this.priceRating,
    required this.ethicalRating,
    required this.websiteUrl,
    required this.imageUrl,
    required this.location
  });

  factory BrandInfo.fromJson(Map<String, dynamic> json) {
    var listCategories = json['categories'] as List;
    var listLocation = json['location'] as List;

    return BrandInfo(
      name: json['name'],
      ethicalInfo1: json['ethicalInfo1'],
      ethicalInfo2: json['ethicalInfo2'],
      categories: listCategories.map((i) => Category.fromJson(i)).toList(),
      logoUrl: json['logoUrl'],
      priceRating: json['price'],
      ethicalRating: json['ethicalRating'],
      websiteUrl: json['website'],
      imageUrl: json['imageUrl'],
      location: listLocation.map((i) => Location.fromJson(i)).toList(),
    );

    //
  }

  String categoriesToString() {
    StringBuffer res = StringBuffer();
    res.write(categories[0].name);
    for (int i = 1; i < categories.length; i++) {
      res.write(", ");
      res.write(categories[i].name);
    }
    return res.toString();
  }
}

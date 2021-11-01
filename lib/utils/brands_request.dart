import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<BrandInfo> fetchBrand(String id) async {
  final response = await http.get(Uri.parse(
      'https://footprintcalculator.herokuapp.com/brands/top-picks/' + id));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return BrandInfo.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load BrandInfo');
  }
}

class Categories {
  final String id;
  final String name;
  final bool isDominant;

  Categories({
    required this.id,
    required this.name,
    required this.isDominant,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
      isDominant: json['isDominant'],
    );
  }
}

class BrandInfo {
  final String name;
  final String ethicalInfo1;
  final String ethicalInfo2;
  final List<Categories> categories;
  final String logoUrl;
  final int priceRating;
  final int ethicalRating;
  final String websiteUrl;
  final String imageUrl;
  // final String location;


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
    //  required this.location
  });

  factory BrandInfo.fromJson(Map<String, dynamic> json) {
    var listCategories = json['categories'] as List;

    return BrandInfo(
      name: json['name'],
      ethicalInfo1: json['ethicalInfo1'],
      ethicalInfo2: json['ethicalInfo2'],
      categories: listCategories.map((i) => Categories.fromJson(i)).toList(),
      logoUrl: json['logoUrl'],
      priceRating: json['price'],
      ethicalRating: json['ethicalRating'],
      websiteUrl: json['website'],
      imageUrl: json['imageUrl'],
      // location: json['location'],
    );
  }
}

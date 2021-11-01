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

class BrandInfo {
  final String name;
  final String description;
 // final String category;
  final String logoUrl;
  final int priceRating;
  final int ethicalRating;
  final String websiteUrl;
 // final String location;

  BrandInfo({
    required this.name,
    required this.description,
   // required this.category,
    required this.logoUrl,
    required this.priceRating,
    required this.ethicalRating,
    required this.websiteUrl,
  //  required this.location
  });

  factory BrandInfo.fromJson(Map<String, dynamic> json) {
    return BrandInfo(
      name: json['name'],
      description: json['ethicalInfo1'],
      //category: json['categories'],
      logoUrl: json['logoUrl'],
      priceRating: json['price'],
      ethicalRating: json['ethicalRating'],
      websiteUrl: json['website'],
     // location: json['location'],
    );
  }
}

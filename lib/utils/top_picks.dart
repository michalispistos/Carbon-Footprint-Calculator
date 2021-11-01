import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<TopPicks> parseTopPicks(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<TopPicks>((json) => TopPicks.fromJson(json)).toList();
}

Future<List<TopPicks>> fetchTopPicks(http.Client client) async {
  final response = await client.get(
      Uri.parse('https://footprintcalculator.herokuapp.com/brands/top-picks'));

  return compute(parseTopPicks, response.body);
}

class TopPicks {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final String ethicalLabel;
  final int ethicalRating;
  final int price;

  TopPicks({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.ethicalLabel,
    required this.ethicalRating,
    required this.price
  });

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

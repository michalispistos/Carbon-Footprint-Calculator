import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint_calculator/data/album.dart';


String title = "";

fetchAlbum() async {

  String key = "1hkn6xmlz11b0fo4cgnne9yhfq1cgo";
  print("hello");
  title = "lol";

    final response = await http.get(Uri.parse('https://api.barcodelookup.com/v3/products?barcode=3614272049529&formatted=y&key=1hkn6xmlz11b0fo4cgnne9yhfq1cgo'));
    print("here");
    // final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      title = "title";
      print("here1");
      return ;
    } else {
      print("here2");
      title = "yoo";
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album3');

  }


}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<Album> futureAlbum;

  // @override
  // void initState() {
  //   super.initState();
  //   futureAlbum = fetchAlbum();
  // }

  @override
  Widget build(BuildContext context) {
    fetchAlbum();

    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: Text(title),
          ),
        ),
    );
  }
}
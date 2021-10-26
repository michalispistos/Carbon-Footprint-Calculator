import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint_calculator/data/album.dart';


String title = "";

Future<Album> fetchAlbum() async {

  String key = "1kv0c3pwix7fr73b47v66vkvmvycnj";
  print("hello");
  title = "lol";
  try{
    final response = await http.get(Uri.parse('https://api.barcodelookup.com/v3/products?barcode=9780140157376&formatted=y&key=1kv0c3pwix7fr73b47v66vkvmvycnj')
    , );
    print("here");
    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      title = jsonData['title'];

      return Album.fromJson(jsonDecode(response.body));
    } else {
      title = "yoo";
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album3');
    }
  }catch(err){
    title = "rere";
    throw Exception('Failed to load album2');
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
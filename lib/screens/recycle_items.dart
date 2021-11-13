import 'dart:convert';

import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;
import 'dart:core';

class RecycleYourClothes extends StatefulWidget {
  @override
  _RecycleYourClothesState createState() => _RecycleYourClothesState();
}

class _RecycleYourClothesState extends State<RecycleYourClothes> {
  late Position _currentPosition = Position(
      longitude: 2,
      latitude: 2,
      timestamp: DateTime(2020),
      accuracy: 2,
      altitude: 2,
      heading: 2,
      speed: 2,
      speedAccuracy: 2);
  TextEditingController postCodeController = TextEditingController();
  late List<RecyclingCentre> recyclingCentres;

  @override
  void initState() {
    super.initState();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        postCodeController.text = "${place.postalCode}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return
      SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(children: const <Widget>[
              Icon(Icons.location_on),
              SizedBox(
                width: 8,
              ),
              Text('Enter your postcode',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
            ])),
        addVerticalSpace(20),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(

                controller: postCodeController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10.0),

                  hintText: "i.e SW7 1BA",
                ))),
        addVerticalSpace(20),
        MaterialButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          elevation: 5.0,
          child: const Text("Use Current Location",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              )),
          onPressed: () {
            _getCurrentLocation();
          },
        ),
        addVerticalSpace(20),
        MaterialButton(
          color: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          elevation: 5.0,
          child: const Text("Find closest recycling centres",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              )),
          onPressed: () {
            getClosestRecyclingCentres();
          },
        ),
      ],
    ));
  }

  void getClosestRecyclingCentres() async {
    final response = await http.get(Uri.parse(
        'https://rl.recyclenow.com/widget/www.recyclenow.com/locations/${postCodeController.text}?limit=30&radius=25&materials[]=57&materials[]=58&materials[]=59'));
    if (response.statusCode == 404 || response.statusCode == 500) {
      createErrorDialog(context, "Not a valid postcode!!!");
    } else {
      setState(() {
        recyclingCentres = parseRecyclingCenter(response.body);
      });
    }
  }
}

Future createErrorDialog(BuildContext context, String errorMessage) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error", style: TextStyle(fontSize: 17)),
          content: SizedBox(
              height: 20,
              child: Text(errorMessage,
                  style: const TextStyle(
                    fontSize: 15,
                  ))),
          actions: <Widget>[
            MaterialButton(
              color: const Color.fromRGBO(254, 96, 79, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              elevation: 5.0,
              child: const Text("CLOSE"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

List<RecyclingCentre> parseRecyclingCenter(String responseBody) {
  final parsed = jsonDecode(responseBody)["items"].cast<Map<String, dynamic>>();


  print(parsed);
  List<RecyclingCentre> result = parsed
      .where((json) => json["address"] != null)
      .where((json) => json["name"] != null)
      .where((json) => json["distance"] != null)
      .map<RecyclingCentre>((json) => RecyclingCentre.fromJson(json))
      .toList();

  result = result.where((element) => result.indexOf(element) <15).toList();

  return result;
}

//   Widget _displayRecyclingCenters() {
//     return ListView.builder(
//       itemCount: materialsToPercentages.length,
//       itemBuilder: (BuildContext context, int index) {
//         String key = materialsToPercentages.keys.elementAt(index);
//         return Column(
//           children: <Widget>[
//             SizedBox(
//                 width: 260,
//                 child:
//                 Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Expanded(
//                       child: Container(
//                         margin: const EdgeInsets.only(
//                           left: 40,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: ListTile(
//                           title: Text("$key: ${materialsToPercentages[key]}%",
//                               style: const TextStyle(
//                                 fontSize: 15,
//                               )),
//                         ),
//                       )),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () {
//                       setState(() {
//                         materials.add(key);
//                         materials.sort();
//                         materialsToPercentages.remove(key);
//                       });
//                     },
//                   )
//                 ])),
//             const SizedBox(height: 10)
//           ],
//         );
//       },
//     );
//   }
//
//   }

class RecyclingCentre {
  final String name;
  final String address;
  final double distance;

  RecyclingCentre({
    required this.name,
    required this.address,
    required this.distance,
  }
  );

  factory RecyclingCentre.fromJson(Map<String, dynamic> json) {
    return RecyclingCentre(
      name: json['name'] as String,
      address: json['address'] as String,
      distance: double.parse(json['distance'].toString()),
    );
  }

  @override
  String toString() {
    return "{name: $name, address:$address, distance:$distance";
  }
}

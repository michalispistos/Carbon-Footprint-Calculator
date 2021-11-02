import 'dart:collection';

import 'package:carbon_footprint_calculator/screens/your_score.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/item.dart';
import 'package:carbon_footprint_calculator/utils/globals.dart' as globals;

class ClothesList extends StatefulWidget {
  const ClothesList({Key? key}) : super(key: key);

  @override
  _ClothesListState createState() => _ClothesListState();
}

class _ClothesListState extends State<ClothesList> {
  List<Clothing> allClothes = [];
  List<Clothing> clothes = [];
  String typeDropdownValue = 'All';
  String scoreDropdownValue = 'All';

  @override
  void initState() {
    super.initState();
    fetchClothesInventory().then((value) => {
      setState(() {
        allClothes = value;
        clothes = allClothes;
    })
    });
  }

  bool isClothesRemoved(
      Clothing clothes, typeDropdownValue, scoreDropdownValue) {
    if (typeDropdownValue == "All" && scoreDropdownValue == "All") {
      return false;
    }
    if (typeDropdownValue == "All") {
      return double.parse(scoreDropdownValue.substring(1)) < clothes.carbonScore;
    }
    if (scoreDropdownValue == "All") {
      return typeDropdownValue != clothes.type;
    }

    return typeDropdownValue != clothes.type ||
        double.parse(scoreDropdownValue.substring(1)) < clothes.carbonScore;
  }

  List<Clothing> filteredClothes(
      List<Clothing> allClothes, typeDropdownValue, scoreDropdownValue) {
    return List.from(allClothes)
      ..removeWhere(
          (c) => isClothesRemoved(c, typeDropdownValue, scoreDropdownValue));
  }

  Widget _displayClothes() {
    clothes =
        filteredClothes(allClothes, typeDropdownValue, scoreDropdownValue);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 5),
      itemCount: clothes.length,
      itemBuilder: (BuildContext context, int index) {
        Clothing clothing = clothes.elementAt(index);
        String iconPath = "images/top.png";
        if (clothing.type == "Bottoms") {
          iconPath = "images/bottom.png";
        }
        if (clothing.type == "Shoes") {
          iconPath = "images/shoes.png";
        }
        return Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              BorderIcon(
                  height: 40,
                  width: 40,
                  bgColor: const Color(0xffffe8ec),
                  child: Image.asset(iconPath)),
              addHorizontalSpace(10),
              Expanded(
                child: ListTile(
                  title: Row(
                    children: [
                      Text(clothing.name,
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                      const Spacer(),
                      Text(clothing.carbonScore.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 5),
            const Divider(color: Colors.black),
          ],
        );
      },
    );
  }

  double totalCarbonFootprint() {
    double totalScore = 0;
    for (Clothing c in clothes) {
      totalScore += c.carbonScore;
    }

    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(children: [
            // const SizedBox(width: 10),
            const Text("Filter         ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),
            const Text("Type   ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),
            DropdownButton(
              hint: Text(typeDropdownValue),
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Color.fromRGBO(64, 133, 72, 1)),
              underline: Container(
                height: 2,
                color: const Color.fromRGBO(64, 133, 72, 1),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  typeDropdownValue = newValue!;
                });
              },
              items: <String>['All', 'Tops', 'Bottoms', 'Shoes']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
            ),
            const SizedBox(width: 10),
            const Text("Score   ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),
            DropdownButton(
              hint: Text(scoreDropdownValue),
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Color.fromRGBO(64, 133, 72, 1)),
              underline: Container(
                height: 2,
                color: const Color.fromRGBO(64, 133, 72, 1),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  scoreDropdownValue = newValue!;
                });
              },
              items: <String>['All', '<75', '<50', '<25']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(children: [
            Text("Type", style: Theme.of(context).textTheme.headline5),
            addHorizontalSpace(33),
            Text("Name", style: Theme.of(context).textTheme.headline5),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child:
                  Text("Score", style: Theme.of(context).textTheme.headline5),
            )
          ]),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: _displayClothes(),
        )),
        Center(
            child: Text(
                "${clothes.length} items in total    Total score: ${totalCarbonFootprint().toStringAsFixed(2)}"))
      ],
    );
  }
}

import 'dart:collection';

import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/item.dart';

class YourClothes extends StatelessWidget {
  const YourClothes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Your Clothes',
              style: TextStyle(
                fontSize: 15,
              )),
        ),
        body: const ClothesList());
  }
}

class ClothesList extends StatefulWidget {
  const ClothesList({Key? key}) : super(key: key);

  @override
  _ClothesListState createState() => _ClothesListState();
}

class _ClothesListState extends State<ClothesList> {
  Map<String, Item> allClothes = HashMap();
  Map<String, Item> clothes = HashMap();
  String typeDropdownValue = 'All';
  String scoreDropdownValue = 'All';

  void createClothes() {
    allClothes.putIfAbsent("Adidas shirt",
        () => Item.itemWithScore(Item({"Acrylic": 100}, "Top", 34.5), 20));
    allClothes.putIfAbsent("Nike trainers",
        () => Item.itemWithScore(Item({"Acrylic": 100}, "Shoes", 2.5), 14));
    allClothes.putIfAbsent("Gucci shoes",
        () => Item.itemWithScore(Item({"Acrylic": 100}, "Shoes", 34.5), 45));
    allClothes.putIfAbsent("Dress",
        () => Item.itemWithScore(Item({"Acrylic": 100}, "Top", 34.5), 5));
    allClothes.putIfAbsent("T-shirt",
        () => Item.itemWithScore(Item({"Acrylic": 100}, "Top", 34.5), 67));
    allClothes.putIfAbsent("Underwear",
        () => Item.itemWithScore(Item({"Acrylic": 100}, "Bottom", 34.5), 78));
    allClothes.putIfAbsent("Jeans",
        () => Item.itemWithScore(Item({"Acrylic": 100}, "Bottom", 34.5), 57));
  }

  bool isItemRemoved(String name, Item item,typeDropdownValue,scoreDropdownValue){
    if(typeDropdownValue == "All" && scoreDropdownValue == "All"){
      return false;
    }
    if(typeDropdownValue == "All"){
      return  double.parse(scoreDropdownValue.substring(1)) < item.score;
    }
    if(scoreDropdownValue == "All"){
      return typeDropdownValue != item.type;
    }

    return typeDropdownValue != item.type || double.parse(scoreDropdownValue.substring(1)) < item.score;
  }

  Map<String, Item> filteredClothes(Map<String, Item> allClothes,typeDropdownValue,scoreDropdownValue){
    return Map.from(allClothes)..removeWhere((k, v) => isItemRemoved(k,v,typeDropdownValue,scoreDropdownValue));
  }

  Widget _displayClothes() {

    clothes = filteredClothes(allClothes, typeDropdownValue, scoreDropdownValue);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 5),
      itemCount: clothes.length,
      itemBuilder: (BuildContext context, int index) {
        String key = clothes.keys.elementAt(index);
        String iconPath = "images/top.png";
        if (clothes[key]?.type == "Bottom") {
          iconPath = "images/bottom.png";
        }
        if (clothes[key]?.type == "Shoes") {
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
                      Text("$key",
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                      const Spacer(),
                      Text("${clothes[key]?.score}",
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
    for(Item c in clothes.values){
      totalScore += c.score;
    }

    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    createClothes();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(children:  [
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
              style: const TextStyle(color: Colors.green),
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  typeDropdownValue = newValue!;
                });
              },
              items:  <String>['All', 'Top', 'Bottom', 'Shoes']
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
              style: const TextStyle(color: Colors.green),
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  scoreDropdownValue = newValue!;
                });
              },
              items:  <String>['All', '<75', '<50', '<25']
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
        Center(child:Text("${clothes.length} items in total    Total score: ${totalCarbonFootprint()}"))
      ],
    );
  }


}

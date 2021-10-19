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

  bool isItemRemoved(String name, Item item){
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

  Widget _displayClothes() {
    Map<String, Item> clothes = HashMap();
    clothes = Map.from(allClothes)..removeWhere((k, v) => isItemRemoved(k,v));

    return ListView.builder(
      itemCount: clothes.length,
      itemBuilder: (BuildContext context, int index) {
        String key = clothes.keys.elementAt(index);
        String icon_path = "images/top.png";
        if (clothes[key]?.type == "Bottom") {
          icon_path = "images/bottom.png";
        }
        if (clothes[key]?.type == "Shoes") {
          icon_path = "images/shoes.png";
        }
        return Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(width: 10),
              BorderIcon(
                  height: 40,
                  width: 40,
                  bgColor: const Color(0xffffe8ec),
                  child: Image.asset(icon_path)),
              addHorizontalSpace(10),
              Expanded(
                child: ListTile(
                  title: Text("$key   ${clothes[key]?.score}",
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            const Divider(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    createClothes();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(children:  [
          const SizedBox(width: 10),
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: SizedBox(height: 490, child: _displayClothes()))
        ]),
      ],
    );
  }
}

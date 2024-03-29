
import 'package:carbon_footprint_calculator/screens/recycle_item.dart';
import 'package:carbon_footprint_calculator/screens/throw_away_item.dart';
import 'package:carbon_footprint_calculator/screens/your_score.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'give_away_item.dart';

class ClothesList extends StatefulWidget {
  const ClothesList({Key? key}) : super(key: key);

  @override
  _ClothesListState createState() => _ClothesListState();
}

enum SortType {
  ascending,
  descending,
  neutral
}

class _ClothesListState extends State<ClothesList> {
  List<Clothing> allClothes = [];
  List<Clothing> clothes = [];
  String typeDropdownValue = 'All';
  String scoreDropdownValue = 'All';
  String removeDropDownValue = 'Recycle';
  bool isClothingRemoved = false;
  SortType sortType = SortType.neutral;


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
      return double.parse(scoreDropdownValue.substring(1)) <
          clothes.carbonScore;
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
    switch (sortType) {
      case SortType.ascending:
        clothes.sort((a,b)=> a.carbonScore.compareTo(b.carbonScore));
        break;
      case SortType.descending:
        clothes.sort((a,b)=> b.carbonScore.compareTo(a.carbonScore));
        break;
      case SortType.neutral:
        // no-op
        break;
    }


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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(clothing.name,
                              style: const TextStyle(
                                fontSize: 16,
                              ))),
                      Row(
                        children: [
                          Text(clothing.carbonScore.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              createWayOfRemovingClothesDialog(context,clothing);
                            },
                          )
                        ],
                      ),
                    ]),
              )),
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
  Widget build(BuildContext context){

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
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  Text("Score", style: Theme.of(context).textTheme.headline5),
                  IconButton(onPressed: () {
                    setState(() {
                      sortType = SortType.values[
                          (sortType.index + 1) % SortType.values.length];
                    });
                  }, icon: Builder(builder: (BuildContext context) {
                    switch (sortType) {
                      case SortType.ascending:
                        return const Icon(Icons.arrow_drop_up);
                      case SortType.descending:
                        return const Icon(Icons.arrow_drop_down);
                      case SortType.neutral:
                        return const Icon(Icons.compare_arrows);
                    }
                  }))
                ],
              ),
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

  Future createWayOfRemovingClothesDialog(BuildContext context, Clothing clothing) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("How will you get rid of this item?",
                style: TextStyle(fontSize: 17)),
            content: SizedBox(
                height: 50,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                       return
                         DropdownButton(
                    hint: Text(removeDropDownValue,style: TextStyle(color: Colors.black)),
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style:
                        const TextStyle(color: Color.fromRGBO(64, 133, 72, 1)),
                    underline: Container(
                      height: 2,
                      color: const Color.fromRGBO(64, 133, 72, 1),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        removeDropDownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Sell/Donate',
                      'Recycle',
                      'Throw away'
                    ].map((String value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                  );
                })),
            actions: <Widget>[
              MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                elevation: 5.0,
                child: const Text("Go"),
                onPressed: () {
                  if(removeDropDownValue == "Recycle"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          RecycleItem(clothing:clothing)),
                    );
                  } else if (removeDropDownValue == "Sell/Donate") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GiveAwayItem(clothing)),
                    );
                  } else if (removeDropDownValue == "Throw away") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ThrowAwayItem(clothing)),
                    );
                  }
                },
              ),
              MaterialButton(
                color: const Color.fromRGBO(254, 96, 79, 1.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                elevation: 5.0,
                child: const Text("CLOSE"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    removeDropDownValue = "Recycle";
                  });
                },
              )
            ],
          );
        });
  }
}

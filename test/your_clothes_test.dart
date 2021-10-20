import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/screens/your_clothes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:collection';

void main() {
  final clothesList = const ClothesList().createState();
  Map<String, Item> allClothes = HashMap();

  Item item1 = Item.itemWithScore(Item({"Acrylic": 100}, "Top", 34.5),20);
  Item item2 = Item.itemWithScore(Item({"Acrylic": 100}, "Shoes", 2.5), 14);
  Item item3 = Item.itemWithScore(Item({"Acrylic": 100}, "Shoes", 34.5), 45);
  Item item4 = Item.itemWithScore(Item({"Acrylic": 100}, "Top", 34.5), 5);
  Item item5 = Item.itemWithScore(Item({"Acrylic": 100}, "Top", 34.5), 67);
  Item item6 = Item.itemWithScore(Item({"Acrylic": 100}, "Bottom", 34.5), 78);
  Item item7 =  Item.itemWithScore(Item({"Acrylic": 100}, "Bottom", 34.5), 57);

  void createClothes() {

    allClothes.putIfAbsent("Adidas shirt",
            () => item1);
    allClothes.putIfAbsent("Nike trainers",
            () => item2);
    allClothes.putIfAbsent("Gucci shoes",
            () => item3);
    allClothes.putIfAbsent("Dress",
            () => item4);
    allClothes.putIfAbsent("T-shirt",
            () => item5);
    allClothes.putIfAbsent("Underwear",
            () => item6);
    allClothes.putIfAbsent("Jeans",
            () => item7);
  }

  createClothes();

  test('if both type and score are All filtering should return original list', () {

    var clothes = clothesList.filteredClothes(allClothes, "All", "All");

    expect(clothes, allClothes);
  });

  test('if type is All and score is <50 filtering should return only clothes with score less than 50', () {

    var clothes = clothesList.filteredClothes(allClothes, "All", "<50");

    Map<String, Item> expectedClothes = HashMap();

    expectedClothes.putIfAbsent("Adidas shirt",
            () => item1);
    expectedClothes.putIfAbsent("Nike trainers",
            () => item2);
    expectedClothes.putIfAbsent("Gucci shoes",
            () => item3);
    expectedClothes.putIfAbsent("Dress",
            () => item4);


    expect(clothes, expectedClothes);
  });

  test('if type is top and score is All filtering should return only clothes that are tops', () {

    var clothes = clothesList.filteredClothes(allClothes, "Top", "All");

    Map<String, Item> expectedClothes = HashMap();

    expectedClothes.putIfAbsent("Adidas shirt",
            () => item1);
    expectedClothes.putIfAbsent("Dress",
            () => item4);
    expectedClothes.putIfAbsent("T-shirt",
            () => item5);


    expect(clothes, expectedClothes);
  });

  test('if type is shoes and score is <25 filtering should return only clothes that are shoes with score <25', () {

    var clothes = clothesList.filteredClothes(allClothes, "Shoes", "<25");

    Map<String, Item> expectedClothes = HashMap();

    expectedClothes.putIfAbsent("Nike trainers",
            () => item2);


    expect(clothes, expectedClothes);
  });


}
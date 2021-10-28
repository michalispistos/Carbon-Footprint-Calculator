import 'package:carbon_footprint_calculator/data/item.dart';

class BarcodeItems {

  static final Map<String, Item> sampleBarcodeItems =
  {
    "062606": Item.itemWithImageAndName(Item({"Cotton": 75,"Polyester": 25}, "Bottom",0.7), 'images/imperial_sweatpants.png',"Imperial Sweatpants"),
    "062335": Item.itemWithImageAndName(Item({"Cotton": 65,"Polyester": 35}, "Top", 0.4), 'images/imperial_hoody.png', "Imperial Hoody"),
    "062431": Item.itemWithImageAndName(Item({"Cotton": 80,"Polyester": 20}, "Top", 0.3), 'images/imperial_sweater.png', "Imperial Sweater"),
    "28003472": Item.itemWithImageAndName(Item({"Polyester": 100}, "Top",1.1), 'images/imperial_jacket.png',"Imperial Jacket"),
    "062522": Item.itemWithImageAndName(Item({"Cotton": 100}, "Top", 0.25), 'images/imperial_t-shirt.png', "Imperial T-shirt"),

    "5000207007159": Item.itemWithImageAndName(Item({"Acrylic": 100}, "Top", 34.5), 'images/northface-logo.png', "North"),
  };
}
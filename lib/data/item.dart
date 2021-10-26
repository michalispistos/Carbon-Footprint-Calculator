class Item {
  // eg. (cotton, 0.87)
  final Map<String, double> materials;
  // TODO could make enums
  final String type;
  // Stored in grams
  final double weight;
  // TODO barcode - store as id? use external package?
  double score = 0;

  String name = "";

  // All the doubles in materials should sum to 1 - currently this is a pre
  // condition assumed here
  Item(this.materials, this.type, this.weight);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['materials'], json['type'], json['weight'],);
  }

  Item.itemWithScore(Item item, this.score):
    materials = item.materials,
    type = item.type,
    weight = item.weight
  ;



}


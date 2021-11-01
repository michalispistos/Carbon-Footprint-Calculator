class Album {
  final int brand;
  final int weight;
  final String title;

  Album({
    required this.brand,
    required this.weight,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      brand: json['brand'],
      weight: json['weight'],
      title: json['title'],
    );
  }
}
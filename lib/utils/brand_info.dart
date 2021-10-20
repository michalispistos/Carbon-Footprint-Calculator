import 'package:flutter/cupertino.dart';

class BrandInfo {
  BrandInfo({
    required this.name,
    required this.description,
    required this.rating,
    required this.logoPath,
    required this.websiteLink,
    required this.basedIn,
    required this.priceRange,
    required this.style,
    required this.goodOnYouLink,
  });

  String name;
  String description;
  int rating;
  String logoPath;
  String websiteLink;
  String basedIn;
  String priceRange;
  String style;
  String goodOnYouLink;

}
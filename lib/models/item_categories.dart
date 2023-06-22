enum Categories { bestSelling, favourites, monster, cult, redBull, bold }

extension CategroriesExtension on Categories {
  String get displayName {
    switch (this) {
      case Categories.bestSelling:
        return "Best selling";
      case Categories.favourites:
        return "Favorites";
      case Categories.monster:
        return "Monster";
      case Categories.cult:
        return "Cult";
      case Categories.redBull:
        return "Red Bull";
      case Categories.bold:
        return "Bold";
    }
  }

  List<Categories> get getBrands => [
        Categories.monster,
        Categories.cult,
        Categories.redBull,
        Categories.bold
      ];

  bool get isBrand => getBrands.contains(this);
}

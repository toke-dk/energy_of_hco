enum TopCategories { all, favourite, bestSelling }

extension TopCategoiresExtienstion on TopCategories {
  String get displayName {
    switch (this) {
      case TopCategories.all:
        return "All";
      case TopCategories.bestSelling:
        return "Best Selling";
      case TopCategories.favourite:
        return "Favourite";
    }
  }
}

enum Brands { monster, cult, redBull, bold, rock, vitamin, faxeKondi, state, powerade, }

extension BrandsExtenstion on Brands {
  String get displayName {
    switch (this) {
      case Brands.monster:
        return "Monster";
      case Brands.cult:
        return "Cult";
      case Brands.redBull:
        return "Red Bull";
      case Brands.bold:
        return "Bold";
      case Brands.rock:
        return "Rock";
      case Brands.vitamin:
        return "Vitamin";
      case Brands.faxeKondi:
        return "Faxe Kondi";
      case Brands.state:
        return "State";
      case Brands.powerade:
        return "Powerade";
    }
  }
}

// To parse this JSON data, do
//
//     final Menus = MenusFromJson(jsonString);

import 'dart:convert';

Menus MenusFromJson(String str) => Menus.fromJson(json.decode(str));

String MenusToJson(Menus data) => json.encode(data.toJson());

class Menus {
  Menus({
    this.menuVersion,
    this.menu,
    this.sugar,
    this.ice,
  });

  String menuVersion;
  List<Menu> menu;
  List<Ice> sugar;
  List<Ice> ice;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        menuVersion: json["menu_version"],
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
        sugar: List<Ice>.from(json["sugar"].map((x) => Ice.fromJson(x))),
        ice: List<Ice>.from(json["ice"].map((x) => Ice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu_version": menuVersion,
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
        "sugar": List<dynamic>.from(sugar.map((x) => x.toJson())),
        "ice": List<dynamic>.from(ice.map((x) => x.toJson())),
      };
}

class Ice {
  Ice({
    this.id,
    this.tag,
  });

  String id;
  String tag;

  factory Ice.fromJson(Map<String, dynamic> json) => Ice(
        id: json["id"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
      };
}

class Menu {
  Menu({
    this.series,
    this.items,
  });

  String series;
  List<Item> items;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        series: json["series"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "series": series,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.item,
    this.flavor,
    this.prices,
    this.cold,
    this.hot,
  });

  int id;
  String item;
  List<String> flavor;
  Prices prices;
  bool cold;
  bool hot;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        item: json["item"],
        flavor: json["flavor"] == null
            ? null
            : List<String>.from(json["flavor"].map((x) => x)),
        prices: Prices.fromJson(json["prices"]),
        cold: json["cold"],
        hot: json["hot"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item": item,
        "flavor":
            flavor == null ? null : List<dynamic>.from(flavor.map((x) => x)),
        "prices": prices.toJson(),
        "cold": cold,
        "hot": hot,
      };
}

class Prices {
  Prices({
    this.large,
    this.medium,
  });

  int large;
  int medium;

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        large: json["large"],
        medium: json["medium"],
      );

  Map<String, dynamic> toJson() => {
        "large": large,
        "medium": medium,
      };
}

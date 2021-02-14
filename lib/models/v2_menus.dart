// To parse this JSON data, do
//
//     final menus = menusFromJson(jsonString);

import 'dart:convert';

Menus menusFromJson(String str) => Menus.fromJson(json.decode(str));

String menusToJson(Menus data) => json.encode(data.toJson());

class Menus {
  Menus({
    this.statusMessage,
    this.payload,
  });

  String statusMessage;
  Payload payload;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        statusMessage: json["status_message"],
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "status_message": statusMessage,
        "payload": payload.toJson(),
      };
}

class Payload {
  Payload({
    this.menuVersion,
    this.menu,
    this.sugar,
    this.ice,
  });

  String menuVersion;
  List<Menu> menu;
  List<Sugar> sugar;
  List<Ice> ice;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        menuVersion: json["menu_version"],
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
        sugar: List<Sugar>.from(json["sugar"].map((x) => Sugar.fromJson(x))),
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
    this.iceId,
    this.iceTag,
  });

  int iceId;
  String iceTag;

  factory Ice.fromJson(Map<String, dynamic> json) => Ice(
        iceId: json["ice_id"],
        iceTag: json["ice_tag"],
      );

  Map<String, dynamic> toJson() => {
        "ice_id": iceId,
        "ice_tag": iceTag,
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
    this.itemId,
    this.item,
    this.mediumPrice,
    this.largePrice,
    this.cold,
    this.hot,
  });

  int itemId;
  String item;
  int mediumPrice;
  int largePrice;
  bool cold;
  bool hot;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["item_id"],
        item: json["item"],
        mediumPrice: json["medium_price"],
        largePrice: json["large_price"],
        cold: json["cold"],
        hot: json["hot"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "item": item,
        "medium_price": mediumPrice,
        "large_price": largePrice,
        "cold": cold,
        "hot": hot,
      };
}

class Sugar {
  Sugar({
    this.sugarId,
    this.sugarTag,
  });

  int sugarId;
  String sugarTag;

  factory Sugar.fromJson(Map<String, dynamic> json) => Sugar(
        sugarId: json["sugar_id"],
        sugarTag: json["sugar_tag"],
      );

  Map<String, dynamic> toJson() => {
        "sugar_id": sugarId,
        "sugar_tag": sugarTag,
      };
}

// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.orderBy,
    this.item,
    this.price,
    this.sugarTag,
    this.iceTag,
  });

  String orderBy;
  String item;
  int price;
  String sugarTag;
  String iceTag;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderBy: json["order_by"],
        item: json["item"],
        price: json["price"],
        sugarTag: json["sugar_tag"],
        iceTag: json["ice_tag"],
      );

  Map<String, dynamic> toJson() => {
        "order_by": orderBy,
        "item": item,
        "price": price,
        "sugar_tag": sugarTag,
        "ice_tag": iceTag,
      };
}

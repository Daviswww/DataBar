// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.orderBy,
    this.itemId,
    this.sugar,
    this.ice,
  });

  String orderBy;
  int itemId;
  int sugar;
  int ice;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderBy: json["order_by"],
        itemId: json["item_id"],
        sugar: json["sugar"],
        ice: json["ice"],
      );

  Map<String, dynamic> toJson() => {
        "order_by": orderBy,
        "item_id": itemId,
        "sugar": sugar,
        "ice": ice,
      };
}

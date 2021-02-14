// To parse this JSON data, do
//
//     final Orders = OrdersFromJson(jsonString);

import 'dart:convert';

Orders OrdersFromJson(String str) => Orders.fromJson(json.decode(str));

String OrdersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Orders({
    this.orderDate,
    this.detailOrders,
  });

  DateTime orderDate;
  List<DetailOrder> detailOrders;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orderDate: DateTime.parse(json["order_date"]),
        detailOrders: List<DetailOrder>.from(
            json["detail_orders"].map((x) => DetailOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_date": orderDate.toIso8601String(),
        "detail_orders":
            List<dynamic>.from(detailOrders.map((x) => x.toJson())),
      };
}

class DetailOrder {
  DetailOrder({
    this.orderBy,
    this.orderTime,
    this.item,
    this.size,
    this.sugar,
    this.ice,
  });

  String orderBy;
  DateTime orderTime;
  String item;
  String size;
  String sugar;
  String ice;

  factory DetailOrder.fromJson(Map<String, dynamic> json) => DetailOrder(
        orderBy: json["order_by"],
        orderTime: DateTime.parse(json["order_time"]),
        item: json["item"],
        size: json["size"],
        sugar: json["sugar"],
        ice: json["ice"],
      );

  Map<String, dynamic> toJson() => {
        "order_by": orderBy,
        "order_time": orderTime.toIso8601String(),
        "item": item,
        "size": size,
        "sugar": sugar,
        "ice": ice,
      };
}

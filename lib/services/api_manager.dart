import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drink_bot/models/v2_menus.dart';
import 'package:drink_bot/models/v2_orders.dart';

class API_Manager {
  static String domin = 'http://140.114.85.21:5000';
  // static String domin = 'http://localhost:5000';
  Future<Menus> getMenus() async {
    var menus;
    final response = await http.get(domin + '/v1/menus/');
    print(response.statusCode);
    try {
      // If the server did return a 200 OK response,
      if (response.statusCode == 200) {
        menus = Menus.fromJson(jsonDecode(response.body));
      }
    } catch (Exception) {
      print("Failed to load Menus");
      return menus;
    }
    return menus;
  }

  Future<Orders> getOrders() async {
    var orders;
    final response = await http.get(domin + '/v1/orders/');
    print(response.statusCode);
    try {
      // If the server did return a 200 OK response,

      if (response.statusCode == 200) {
        orders = Orders.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 202) {
        orders = Orders.fromJson(jsonDecode(response.body));
      }
    } catch (Exception) {
      print("Failed to load Orders");
      return orders;
    }
    return orders;
  }

  Future<http.Response> postOrder(
      String order, String size, int itemId, int sugar, int ice) async {
    final url = domin + '/v1/orders/';
    Map data = {
      "order_by": order,
      "size": size,
      "item_id": itemId,
      "sugar_id": sugar,
      "ice_id": ice
    };
    final body = jsonEncode(data);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        return response;
      }
      if (response.statusCode == 201) {
        return response;
      }
      if (response.statusCode == 307) {
        return response;
      }
    } catch (Exception) {
      print("Failed to post Order");
      print(Exception);
      return null;
    }
    return response;
  }
}

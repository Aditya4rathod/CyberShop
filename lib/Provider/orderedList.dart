import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderListItem {
  final String date = DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now());
  final String name;
  final double price;
  final String image;
  final int quantity;
  final int id;

  OrderListItem({
    required this.name,
    required this.price,
    required this.image,
    required this.id,
    this.quantity = 1,
  });
}

class OrderList with ChangeNotifier {
  List<OrderListItem> _list = [];

  List<OrderListItem> get items => _list;

  int get itemCount {
    return _list.length;
  }

  void addItem(OrderListItem orderListItem) {
    _list.add(orderListItem);
    notifyListeners();
  }

void placeOrder(String cartId, String cartTotal )async{
  try {
    print(cartId);
    print(cartTotal);
    SharedPreferences preference = await SharedPreferences.getInstance();
    String? jwtToken = preference.getString('jwt');
    var response = await http.post(
      Uri.parse("https://shopping-app-backend-t4ay.onrender.com/order/placeOrder"),
      body: {
        "cartId": cartId,
        "cartTotal": cartTotal
      },
      headers: {
        "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(response.statusCode);
      print(responseBody);
    } else {
      print(response.statusCode);
    }
  } catch (e) {
    print(e.toString());
  }
  notifyListeners();
}

}


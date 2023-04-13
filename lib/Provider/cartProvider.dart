import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Cart{
  int id;
  String name;
  double price;
  String image;
  bool fill;
  int quantity;

  Cart({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.fill,
    required this.quantity,

  });
}

class CartNotifier extends ChangeNotifier {
  List<Cart> _data = [];

  List<Cart> get listData => _data;


   addToCart(String productId) async {
    try {
      print(productId);
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      print(jwtToken);
      var response = await http.post(
        Uri.parse("https://shopping-app-backend-t4ay.onrender.com/cart/addToCart"),
        body: {
          "productId": productId,
        },
        headers: {
          "Authorization": "Bearer $jwtToken",
        },
      );

      if (response.statusCode == 201) {
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

  void removeFromCart(String cartItemId) async {
    try {
      print(cartItemId);
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      var response = await http.post(
        Uri.parse("https://shopping-app-backend-t4ay.onrender.com/cart/removeProductFromCart"),
        body: {
          "cartItemId": cartItemId,
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


  void increaseProductQuantity(String cartItemId) async {
    try {
      print(cartItemId);
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      var response = await http.post(
        Uri.parse("https://shopping-app-backend-t4ay.onrender.com/cart/increaseProductQuantity"),
        body: {
          "cartItemId": cartItemId,
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

  void decreaseProductQuantity(String cartItemId) async {
    try {
      print(cartItemId);
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      var response = await http.post(
        Uri.parse("https://shopping-app-backend-t4ay.onrender.com/cart/decreaseProductQuantity"),
        body: {
          "cartItemId": cartItemId,
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



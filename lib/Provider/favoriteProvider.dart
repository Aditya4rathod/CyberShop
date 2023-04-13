import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Favorite{
  int id;
  String name;
  double price;
  String image;
  bool fill;

  Favorite({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.fill,

});
}

class FavoriteNotifier extends ChangeNotifier {
  List<Favorite> _items = [];

  List<Favorite> get itemData => _items;

  void addToFavorite(Favorite product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromFavorite(Favorite product) {
    _items.remove(product);
    notifyListeners();
  }


  int get itemCount {
    return _items.length;
  }

  void clearItem() {
    _items = [];
    notifyListeners();
  }

  void addToWishlist(String productId) async {
    try{
      print(productId);
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      print(jwtToken);
      var response = await http.post(Uri.parse("https://shopping-app-backend-t4ay.onrender.com/watchList/addToWatchList") , body: {
        "productId" : productId,
      },
        headers: {
          "Authorization" : "Bearer $jwtToken",
        },
      );


      if(response.statusCode == 200){
        var responseBody = jsonDecode(response.body);
        print(response.statusCode);
        print(responseBody);
      }
      else {
        print(response.statusCode);
      }
    }
    catch(e){
      print(e.toString());
    }
    notifyListeners();
  }

  void removeFromFav(String wathListItemId) async {
    try {
      print(wathListItemId);
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      var response = await http.post(
        Uri.parse("https://shopping-app-backend-t4ay.onrender.com/watchList/removeFromWatchList"),
        body: {
          "wathListItemId": wathListItemId,
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


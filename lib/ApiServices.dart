import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_ordering_system/models/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class FetchUserList{
  var data = [];

  List<ProductModel> productList = [];

  Future<List<ProductModel>> getProduct({String? query}) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String? jwtToken = preference.getString('jwt');
    String api = "https://shopping-app-backend-t4ay.onrender.com/product/getAllProduct";
    final Header = {"Authorization": "Bearer $jwtToken"};
    var response = await http.get(Uri.parse(api), headers: Header);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      // var data = responseBody['data'];
      // pref(id);

 productList = data.map((e) => ProductModel.fromJson(e)).toList();
      if (query!= null){
        productList = productList.where((element) => element.data[0].title!.toLowerCase().contains((query.toLowerCase()))).toList();
      }
      print(response.statusCode);
      print(responseBody);
      // if (query!= null){
      //   productList = productList.where((element) => element.data[0].title!.toLowerCase().contains((query.toLowerCase()))).toList();
      // }
      return productList;
    }
    else {
      var responseBody = jsonDecode(response.body);
      print(response.statusCode);
      print(responseBody);
      return productList;
    }
  }
}
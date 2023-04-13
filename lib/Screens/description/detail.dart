import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_ordering_system/Provider/cartProvider.dart';
import 'package:online_ordering_system/Provider/favoriteProvider.dart';
import 'package:online_ordering_system/models/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/productModel.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({Key? key ,
  }) : super(key: key);


  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {


  void addToCart(String productId) async {
    try{
      print(productId);
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      var response = await http.post(Uri.parse("https://shopping-app-backend-t4ay.onrender.com/cart/addToCart") , body: {
        "productId" : productId,
      },
        headers: {
          "Authorization" : "Bearer $jwtToken",
        },
      );


      if(response.statusCode == 201){
        var responsebody = jsonDecode(response.body);
        print(response.statusCode);
        print(responsebody);
      }
      else {
        var responsebody = jsonDecode(response.body);
        print(response.statusCode);
      }
    }
    catch(e){
      print(e.toString());
    }
  }


  bool isSelected = false;
  bool descTextShowFlag = false;
  SnackBar snackBar = SnackBar(
      content: Text('Added to cart',
        style: TextStyle(
            color: Color(0xFF0695b4))));

  SnackBar snackBar2 = SnackBar(content: Text('Added to Wishlist', style: TextStyle(color: Colors.red)));


  late Data argument;

  @override
  Widget build(BuildContext context) {
    argument = ModalRoute.of(context)!.settings.arguments as Data;
   // print('id: ${product['_id']}');
  final cart = Provider.of<CartNotifier>(context);
   final favorite = Provider.of<FavoriteNotifier>(context);
    return Scaffold(
      backgroundColor: Color(0xFF181a20),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF181a20),
        title: Text(
          'About Product',
          style: TextStyle(fontSize: 20,color: Color(0xFF0695b4)),
        ),
        // actions: [
        //   argument.watchListItemId != ''
        //       ? GestureDetector(
        //       onTap: () {
        //         favorite.removeFromFav(argument.watchListItemId.toString());
        //
        //       },
        //       child: Icon(
        //         Icons.favorite,
        //         color: Colors.red,
        //         size: 18,
        //       ))
        //       : GestureDetector(
        //       onTap: () {
        //         favorite.addToWishlist(argument.id.toString());
        //       },
        //       child: Icon(
        //         Icons.favorite_outline,
        //         color: Colors.white70,
        //         size: 18,
        //       )
        //   ),
          // IconButton(
          //     onPressed: () {
          //       favorite.addToWishlist(argument.id.toString());
          //       ScaffoldMessenger.of(context).showSnackBar(snackBar2);
          //     },
          //     icon:  isSelected ? Icon(
          //       Icons.favorite,
          //       color: Colors.red) : Icon(
          //         Icons.favorite_outline,
          //       color: Colors.red,
          //     )
          //     )
        //],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 20, 13, 8),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(argument.imageUrl.toString()),
                    fit: BoxFit.contain
                  ),
                  color: Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(argument.title.toString(),
                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)),
                    ),
                    Text(
                      "£" + argument.price.toString(),

                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25, color: Color(0xFF0695b4))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Features : ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white38,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Text(
                  argument.description.toString(),

                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: descTextShowFlag ? 8 : 2,
                    textAlign: TextAlign.start),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      descTextShowFlag = !descTextShowFlag;
                    });
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                    descTextShowFlag
                        ? Text(
                            "Show Less",
                            style: TextStyle(color: Colors.blue),
                          )
                        : Text("Show More", style: TextStyle(color: Colors.blue))
                  ])),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Color(0xFF262a34),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child:  Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 13),
                  height: 48.0,
                  width: 48.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shopping_bag,
                      color: Color(0xFF0695b4),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      addToCart(argument.id.toString());
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text(
                      'buy now'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Color(0xFF0695b4)),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
              ],
            ),
            // child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            //   Expanded(
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         primary: Color(0xFF0695b4),
            //
            //       ),
            //       onPressed: () {
            //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //         //cart.addToCart(Cart(
            //             // id: product.id,
            //             // name: product.title,
            //             // price: product.price,
            //             // image: product.images));
            //       },
            //       child: Text(
            //         "Add to Cart",
            //         style: TextStyle(
            //           color: Colors.white70,
            //           fontSize: 20,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //     ),
            //   ),
            // ]),
          )),
    );
  }


  }

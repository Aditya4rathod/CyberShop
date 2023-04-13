import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_ordering_system/Provider/cartProvider.dart';
import 'package:online_ordering_system/Provider/favoriteProvider.dart';
import 'package:online_ordering_system/models/favoriteModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  bool isSelected = true;
  List<FavoriteModel> favProduct = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWishlist();
  }

  Future<List<FavoriteModel>> getWishlist() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String? jwtToken = preference.getString('jwt');
    String api = "https://shopping-app-backend-t4ay.onrender.com/watchList/getWatchList";
    final Header = {"Authorization": "Bearer $jwtToken"};
    var response = await http.get(Uri.parse(api), headers: Header);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var data = responseBody['data'];
      // pref(id);

      setState(() {
        favProduct = [FavoriteModel.fromJson(responseBody)];
        isLoading = true;
      });
      print(response.statusCode);
      print(responseBody);
      return favProduct;
    } else if (response.statusCode == 500) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return favProduct;
    } else {
      var responseBody = jsonDecode(response.body);
      print(response.statusCode);
      print(responseBody);
      return favProduct;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteNotifier>(context);
    final cart = Provider.of<CartNotifier>(context);
    return Scaffold(
      backgroundColor: Color(0xFF181a20),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/bottoms');
          },
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Wishlist',
          style: TextStyle(
            color: Color(0xFF0695b4),
          ),
        ),
        backgroundColor: Color(0xFF181a20),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: isLoading
              ? favProduct[0].data.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/heart.png',
                          scale: 4.0,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your Wishlist is Empty',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF0695b4)),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/bottoms');
                            },
                            child: Text(
                              'Continue Shopping',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: favProduct[0].data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 1.0,
                          semanticContainer: true,
                          color: Color(0xFF181a20),
                          child: Container(
                            padding: EdgeInsets.only(left: 6.0, right: 6.0),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height / 6,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(favProduct[0].data[index].productDetails.imageUrl), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          favProduct[0].data[index].productDetails.title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            favorite.removeFromFav(favProduct[0].data[index].id.toString());
                                            getWishlist();
                                          },
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: Colors.redAccent,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                cart.addToCart(favProduct[0].data[index].productDetails.id.toString());
                                              },
                                              icon: Icon(
                                                Icons.shopping_bag,
                                                color: Color(0xFF0695b4),
                                              ))
                                        ],
                                      ),
                                      Spacer(),
                                      Text(
                                        '£ ' + favProduct[0].data[index].productDetails.price.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              )),
                            ]),
                          ),
                        );
                      })
              : Center(
                  child: SpinKitCircle(
                  color: Color(0xFF0695b4),
                )
                  // CircularProgressIndicator(
                  //   color: Color(0xFF0695b4),
                  // ),
                  )),
    );
  }
}

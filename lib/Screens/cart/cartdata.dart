import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_ordering_system/Provider/cartProvider.dart';
import 'package:online_ordering_system/Provider/orderedList.dart';
import 'package:online_ordering_system/Screens/Home/Home_Screen.dart';
import 'package:online_ordering_system/components/bottomnavigation.dart';
import 'package:online_ordering_system/models/cartModel.dart';
import 'package:online_ordering_system/models/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;



class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {


  List<CartData> cartProduct = [];
  bool isLoading = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      getCart();
  }

  Future<List<CartData>> getCart() async {
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jwtToken = preference.getString('jwt');
      String api = "https://shopping-app-backend-t4ay.onrender.com/cart/getMyCart";
      final Header = {"Authorization": "Bearer $jwtToken"};
      var response = await http.get(Uri.parse(api), headers: Header);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
         var data = responseBody['data'];

        setState(() {
         cartProduct = [CartData.fromJson(responseBody)];

          isLoading = true;
        });
        print(response.statusCode);
        print(responseBody);
        return cartProduct;
      }
      else if (response.statusCode == 500){
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        return cartProduct;
      }
      else {
        var responseBody = jsonDecode(response.body);
        print(response.statusCode);
        print(responseBody);
        return cartProduct;
      }
  }

  int counter = 1;
  int weight = 1;


  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderList>(context);
    final Cart = Provider.of<CartNotifier>(context);
    return Scaffold(
        backgroundColor: Color(0xFF181a20),
        appBar: AppBar(
          backgroundColor: Color(0xFF262a34),
          centerTitle: true,
          title: Text(
            'My Cart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0695b4),
            ),
          ),
        ),
        body: isLoading ? cartProduct[0].data.isEmpty ? Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/shopping-bag.png', scale: 4.0,),
              SizedBox(height: 20,),
              Text(
                'You have nothing in your Bag',style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              ),
              SizedBox(height: 20,),
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
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

            ],
          ),
        )
        : Column(
          children: [
            Flexible(
              child: ListView.builder(
                      itemCount: cartProduct[0].data.length ,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(5.0, 8.0,12.0,3.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(cartProduct[0].data[index].productDetails.imageUrl), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              cartProduct[0].data[index].productDetails.title,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                              ),

                                            ),
                                          ),

                                          IconButton(
                                              onPressed: () {
                                                Cart.removeFromCart(cartProduct[0].data[index].id.toString());
                                                getCart();
                                                // cart.removeFromCart(cartList.removeAt(index));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.white38,
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 90,
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.grey.withOpacity(.1),
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Cart.decreaseProductQuantity(cartProduct[0].data[index].id.toString());
                                                      getCart();
                                                    },
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 18,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Text(
                                                    cartProduct[0].data[index].quantity.toString(),
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0695b4)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Flexible(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Cart.increaseProductQuantity(cartProduct[0].data[index].id.toString());
                                                      getCart();
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 18,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '£ ' + cartProduct[0].data[index].productDetails.price ,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF0695b4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 4.5,
                decoration: BoxDecoration(
                  color: Color(
                    0xFF262a34,
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Product : ',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 15,
                              ),
                            ),
                            Spacer(),
                            Text( '${cartProduct[0].data.length}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ))
                          ]),
                      Divider(
                        thickness: 1,
                        color: Color(0xFF0695b4),
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Price : ',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              Text( '£ ' + cartProduct[0].cartTotal!.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ))
                            ],
                          )
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          primary: Color(0xFF0695b4),
                          padding: EdgeInsets.fromLTRB(110, 0, 120, 0),
                        ),
                        onPressed: () {
                          showAlertDialog(context);
                          order.placeOrder(cartProduct[0].data[0].cartId.toString(), cartProduct[0].cartTotal.toString());
                          Timer(Duration(seconds: 3), () {
                            Navigator.pushReplacementNamed(context, '/bottoms');
                          });

                        },
                        child: Text(
                          'Check Out',
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      )
                    ])))
          ],
        )
         : Center(
        child : SpinKitCircle(
          color: Color(0xFF0695b4),
        )
        ));
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        backgroundColor: Color(0xFF262a34),
        title: Text(
          "Order Placed🎉",
          style: TextStyle(
            color: Color(0xFF0695b4),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          "Your Order Placed Succesfully!!",
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 15),
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

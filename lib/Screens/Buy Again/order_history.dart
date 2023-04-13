import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_ordering_system/Provider/cartProvider.dart';
import 'package:online_ordering_system/Provider/orderedList.dart';
import 'package:online_ordering_system/models/orderhistoryModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderedModel> orderedProduct = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderedList();
  }

  Future<List<OrderedModel>> getOrderedList() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String? jwtToken = preference.getString('jwt');
    String api = "https://shopping-app-backend-t4ay.onrender.com/order/getOrderHistory";
    final Header = {"Authorization": "Bearer $jwtToken"};
    var response = await http.get(Uri.parse(api), headers: Header);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var data = responseBody['data'];

      setState(() {
        orderedProduct = [OrderedModel.fromJson(responseBody)];

        isLoading = true;
      });
      print(response.statusCode);
      print(responseBody);
      return orderedProduct;
    } else if (response.statusCode == 500) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return orderedProduct;
    } else {
      var responseBody = jsonDecode(response.body);
      print(response.statusCode);
      print(responseBody);
      return orderedProduct;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderList>(context);
    final cart = Provider.of<CartNotifier>(context);
    return Scaffold(
        backgroundColor: Color(0xFF181a20),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF181a20),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bottoms');
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.white,
            ),
          ),
          title: Text(
            'My Orders',
            style: TextStyle(color: Color(0xFF0695b4)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isLoading
              ? orderedProduct[0].data.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Order Placed till now',
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
                      ),
                    )
                  : ListView.builder(
                      itemCount: orderedProduct[0].data.length,
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
                                  image: DecorationImage(image: NetworkImage(orderedProduct[0].data[index].imageUrl), fit: BoxFit.cover),
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
                                          orderedProduct[0].data[index].title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await cart.addToCart(orderedProduct[0].data[index].productId.toString());
                                          },
                                          icon: Icon(
                                            Icons.shopping_bag,
                                            color: Color(0xFF0695b4),
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
                                          RichText(
                                            text: TextSpan(
                                              text: 'quantity: ',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white38,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: orderedProduct[0].data[index].quantity.toString(),
                                                    style: TextStyle(fontSize: 18, color: Color(0xFF0695b4), fontWeight: FontWeight.w900)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Text(
                                        '£ ' + orderedProduct[0].data[index].price.toString(),
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
                )),
        ));
  }
}

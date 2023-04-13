import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_ordering_system/ApiServices.dart';
import 'package:online_ordering_system/Provider/cartProvider.dart';
import 'package:online_ordering_system/models/product.dart';
import 'package:online_ordering_system/Provider/favoriteProvider.dart';
import 'package:online_ordering_system/models/productModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  //FetchUserList _productList = FetchUserList();

  bool isLoading = false;
  TextEditingController userSearch = TextEditingController();
  List<ProductModel> productList = [];
  List<dynamic> searchList = [];
  bool search = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  Future<List<ProductModel>> getProduct() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String? jwtToken = preference.getString('jwt');
    String api = "https://shopping-app-backend-t4ay.onrender.com/product/getAllProduct";
    final Header = {"Authorization": "Bearer $jwtToken"};
    var response = await http.get(Uri.parse(api), headers: Header);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      // var data = responseBody['data'];
      // pref(id);

      setState(() {
        productList = [ProductModel.fromJson(responseBody)];

        isLoading = true;
      });
      print(response.statusCode);
      print(responseBody);
      return productList;
    }
    else if (response.statusCode == 500){
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return productList;
    }
    else {
      var responseBody = jsonDecode(response.body);
      print(response.statusCode);
      print(responseBody);
      return productList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteNotifier>(context);
    final cart = Provider.of<CartNotifier>(context);
    return Column(
      children: [
        SizedBox(
          height: 6,
        ),
        TextFormField(
          controller: userSearch,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
          ),
          // onTap: (){
          //   getProduct(query: userSearch.text);
          // },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(4),
              filled: true,
              fillColor: Color(0xFF262a34),
              hintText: 'Search Product ',
              hintStyle: TextStyle(color: Colors.white38),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF0695b4),
                size: 25,
              ),
              // suffixIcon: GestureDetector(
              //   onTap: (){
              //
              //   },
              //   child: Icon(
              //     Icons.cancel,
              //     color: Colors.white70,
              //     size: 22,
              //   ),
              // ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
              )
          ),
           onChanged: (value){
            List<dynamic> result = [];
            if(value.isEmpty) {
              result = productList;
              setState(() {
                search = false;
              });
            }
            else{
              result = productList[0].data.where((element) => element.title!.toLowerCase().contains((value.toLowerCase()))).toList();
              setState(() {
                search = true;
              });
            }
            searchList = result;
           },
        ),
        Divider(),
        isLoading ?Flexible(
          child: !search ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: productList == null ? 0 : productList[0].data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: productList[0].data[index],
                    );
                  },
                  child: Stack(children: [
                    Card(
                      child: GridTile(
                        child: Image.network(productList[0].data[index].imageUrl, fit: BoxFit.fitHeight),
                        footer: GridTileBar(
                          backgroundColor: Color(0xFF262a34),
                          title: Text(
                            productList[0].data[index].title.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "£" + productList[0].data[index].price,
                            style: TextStyle(
                              color: Color(0xFF0695b4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF262a34),
                              ),
                              child: productList[0].data[index].quantity != 0
                              ? Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      cart.decreaseProductQuantity(productList[0].data[index].cartItemId.toString());
                                      getProduct();
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey.withOpacity(.1),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white70,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        productList[0].data[index].quantity.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0695b4)),
                                      ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      cart.increaseProductQuantity(productList[0].data[index].cartItemId.toString());
                                      getProduct();
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey.withOpacity(.1),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white70,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  : IconButton(
                                      onPressed: () async{
                                        print(productList[0].data[index].id.toString());
                                       await cart.addToCart(productList[0].data[index].id.toString());
                                        getProduct();
                                      },
                                      icon: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Color(0xFF0695b4),
                                      ))),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF262a34),
                          ),
                          child: productList[0].data[index].watchListItemId != ''
                              ? GestureDetector(
                                  onTap: () {
                                    favorite.removeFromFav(productList[0].data[index].watchListItemId.toString());
                                    getProduct();
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 18,
                                  ))
                              : GestureDetector(
                                  onTap: () {
                                    getProduct();
                                    favorite.addToWishlist(productList[0].data[index].id.toString());
                                  },
                                  child: Icon(
                                          Icons.favorite_outline,
                                          color: Colors.white70,
                                          size: 18,
                                        )
                          ),
                        ),
                      ),
                    )
                  ]),
                );
              }) : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: productList[0].data[index],
                    );
                  },
                  child: Stack(children: [
                    Card(
                      child: GridTile(
                        child: Image.network(searchList[index].imageUrl, fit: BoxFit.fitHeight),
                        footer: GridTileBar(
                          backgroundColor: Color(0xFF262a34),
                          title: Text(
                            searchList[index].title.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "£" + searchList[index].price,
                            style: TextStyle(
                              color: Color(0xFF0695b4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF262a34),
                              ),
                              child: productList[0].data[index].quantity != 0
                                  ? Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      cart.decreaseProductQuantity(productList[0].data[index].cartItemId.toString());
                                      getProduct();
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey.withOpacity(.1),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white70,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    productList[0].data[index].quantity.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0695b4)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      cart.increaseProductQuantity(productList[0].data[index].cartItemId.toString());
                                      getProduct();
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey.withOpacity(.1),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white70,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  : IconButton(
                                  onPressed: () async{
                                    print(productList[0].data[index].id.toString());
                                    await cart.addToCart(productList[0].data[index].id.toString());
                                    getProduct();
                                  },
                                  icon: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Color(0xFF0695b4),
                                  ))),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF262a34),
                          ),
                          child: productList[0].data[index].watchListItemId != ''
                              ? GestureDetector(
                              onTap: () {
                                favorite.removeFromFav(productList[0].data[index].watchListItemId.toString());
                                getProduct();
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 18,
                              ))
                              : GestureDetector(
                              onTap: () {
                                getProduct();
                                favorite.addToWishlist(productList[0].data[index].id.toString());
                              },
                              child: Icon(
                                Icons.favorite_outline,
                                color: Colors.white70,
                                size: 18,
                              )
                          ),
                        ),
                      ),
                    )
                  ]),
                );
              }) ,
        ) : SpinKitCircle(
          color: Color(0xFF0695b4),
        )
      ],
    );
  }
}

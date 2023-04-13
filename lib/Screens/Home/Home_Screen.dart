import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_ordering_system/Screens/Home/items.dart';
import 'package:online_ordering_system/Screens/Login/Login_Screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_ordering_system/Screens/search/searchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userSearch = TextEditingController();

  String name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AccountInfo(context);
  }

  AccountInfo(BuildContext context) async{
    final pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name').toString();
    });
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF181a20),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0,left: 20.0, right:  20.0),
        child : Column(
          children: [
               Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // height: 45,
                    // width: 290,
                    decoration: BoxDecoration(
                      //border: Border.all(color: Color(0xFF0695b4)),
                    //  color: Color(0xFF262a34),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Hello ${name},\n',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                        children: const <TextSpan>[
                          TextSpan(text: 'ShopNow',
                              style: TextStyle(
                                fontSize: 25,
                                  color: Color(0xFF0695b4))),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.white70),
                  //     shape: BoxShape.circle,
                  //     color: Color(0xFF262a34),
                  //   ),
                  //   child: IconButton(onPressed: (){
                  //    // showSearch(context: context, delegate: SearchProduct());
                  //     // Navigator.pushNamed(context, '/cart');
                  //   }, icon: Icon(Icons.search,
                  //     color: Color(0xFF0695b4),
                  //   )),
                  // ),
                  // SizedBox(
                  //   width: 7,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70),
                      shape: BoxShape.circle,
                      color: Color(0xFF262a34),
                    ),
                    child: IconButton(onPressed: (){
                      Navigator.pushNamed(context, '/cart');
                    }, icon: Icon(Icons.shopping_cart,
                      color: Color(0xFF0695b4),
                    )),
                  ),
                ],
              ),
            Expanded(child: Products(),)
            ]),
        ),
      ),
    );
  }
}

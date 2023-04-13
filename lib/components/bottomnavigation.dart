
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:online_ordering_system/Screens/Account/Profile_pic.dart';
import 'package:online_ordering_system/Screens/Buy%20Again/order_history.dart';
import 'package:online_ordering_system/Screens/Home/Home_Screen.dart';
import 'package:online_ordering_system/Screens/WishList/wishitems.dart';
import 'package:online_ordering_system/Screens/cart/cartdata.dart';
import 'package:online_ordering_system/Screens/search/searchScreen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _page = 0;
  static List _list = [
    HomeScreen(),
    WishList(),
    //Text('Notification', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue)),
    OrderHistory(),
    //Text('cart', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Colors.blue)),
    ProfilePic(),
    // Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Colors.blue)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF181a20),
        body: Center(
          child: _list.elementAt(_page),
        ),
        bottomNavigationBar:  GNav(
          gap: 5,
          backgroundColor: Color(0xFF181a20),
          color: Colors.white70,
          activeColor: Color(0xFF0695b4),
          padding: EdgeInsets.all(12),
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Wishlist',
            ),
            GButton(
              icon: Icons.history,
              text: 'Buy Again',
            ),
            GButton(
              icon: Icons.account_circle,
              text: 'Account',
            )
          ],
          onTabChange: (index) {
            setState(() {
              _page = index;
            });
          },
        ));
  }
}


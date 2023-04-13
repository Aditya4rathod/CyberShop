import 'package:flutter/material.dart';
import 'package:online_ordering_system/Provider/cartProvider.dart';
import 'package:online_ordering_system/Provider/favoriteProvider.dart';
import 'package:online_ordering_system/Provider/orderedList.dart';
import 'package:online_ordering_system/Provider/registerProvider.dart';
import 'package:online_ordering_system/Screens/Account/Fields/change_pass.dart';
import 'package:online_ordering_system/Screens/Account/Fields/my_account.dart';
import 'package:online_ordering_system/Screens/Buy%20Again/order_history.dart';
import 'package:online_ordering_system/Screens/Home/Home_Screen.dart';
import 'package:online_ordering_system/Screens/Splash_Screen/Splash_Screen.dart';
import 'package:online_ordering_system/Screens/WishList/wishitems.dart';
import 'package:online_ordering_system/Screens/cart/cartdata.dart';
import 'package:online_ordering_system/Screens/description/detail.dart';
import 'package:online_ordering_system/Screens/forgot_pass/Forgot%20Password.dart';
import 'package:online_ordering_system/Screens/Login/Login_Screen.dart';
import 'package:online_ordering_system/Screens/forgot_pass/forgotpass_otp.dart';
import 'package:online_ordering_system/Screens/otp/Otp_Screen.dart';
import 'package:online_ordering_system/Screens/register/Registration_Screen.dart';
import 'package:online_ordering_system/components/bottomnavigation.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterNotifier()),
        ChangeNotifierProvider(create: (_) => CartNotifier()),
        ChangeNotifierProvider(create: (_) => FavoriteNotifier()),
        ChangeNotifierProvider(create: (_) => OrderList()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColorLight: Colors.white38,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginPage(),
          '/otp': (context) => OtpScreen(),
          '/home': (context) => HomeScreen(),
          '/forgot': (context) => ForgotPass(),
          '/forgotpassotp': (context) => ForgotPassOtp(),
          '/bottoms': (context) => BottomNavigation(),
          '/detail': (context) => DetailPage(),
          '/cart': (context) => CartView(),
          '/wishlist': (context) => WishList(),
          '/Myacc': (context) => MyAccount(),
          '/history': (context) => OrderHistory(),
          '/passchange': (context) => ChangePassword(),
        },
      ),
    );
  }
}

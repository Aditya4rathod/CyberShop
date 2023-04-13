import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_ordering_system/Screens/Login/Login_Screen.dart';
import 'package:online_ordering_system/Screens/register/Registration_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void directLogin() async{
    final pref = await SharedPreferences.getInstance();
    var login = pref.getBool('status');
    if(login == true){
      Navigator.pushNamed(context, '/bottoms');
    }
    else{

    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),()async{
      final pref = await SharedPreferences.getInstance();
      var login = pref.getBool('status');
      if(login == true ){
        Navigator.pushReplacementNamed(context, '/bottoms');
      }
      else{
        Navigator.pushNamed(context, '/login');
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/2.webp"),
          fit: BoxFit.cover,
      ),

      ) );
  }
}

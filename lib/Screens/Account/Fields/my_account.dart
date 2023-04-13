
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  String mail = '';
  String name = '';
  String mobileNo = '';

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    AccountInfo(context);
  }

  AccountInfo(BuildContext context) async{
  final pref = await SharedPreferences.getInstance();
   setState(() {
     mail = pref.getString('emailId').toString();
     name = pref.getString('name').toString();
     mobileNo = pref.getString('mobileNo').toString();
   });
  }

// Map<String ,dynamic> argument = {};


  @override
  Widget build(BuildContext context) {
   // argument = ModalRoute.of(context)!.settings.arguments as Map<String , dynamic>;
    return Scaffold(
      backgroundColor: Color(0xFF181a20),
      appBar: AppBar(
        backgroundColor:Color(0xFF181a20),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 70, 13, 13),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text('Account Info.',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),),
                SizedBox(height: 30,),
               Column(
                 children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0 , bottom: 8.0),
                      child: TextFormField(
                        readOnly: true,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF262a34),
              hintText: name,
              hintStyle: TextStyle(color: Colors.white70),
              icon: Icon(
                Icons.account_circle,
                color: Color(0xFF0695b4),
              ),
            ),
          ),
                    ),
                   Padding(
                     padding: const EdgeInsets.only(top: 8.0 , bottom: 8.0),
                     child: TextFormField(
                       readOnly: true,
                       style: TextStyle(
                         color: Colors.white,
                       ),
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Color(0xFF262a34),
                         hintText: mail,
                         hintStyle: TextStyle(color: Colors.white70),
                         icon: Icon(
                           Icons.mail,
                           color: Color(0xFF0695b4),
                         ),
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 8.0 , bottom: 8.0),
                     child: TextFormField(
                       readOnly: true,
                       style: TextStyle(
                         color: Colors.white,
                       ),
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Color(0xFF262a34),
                         hintText: mobileNo,
                         hintStyle: TextStyle(color: Colors.white70),
                         icon: Icon(
                           Icons.call,
                           color: Color(0xFF0695b4),
                         ),
                       ),
                     ),
                   ),
        ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

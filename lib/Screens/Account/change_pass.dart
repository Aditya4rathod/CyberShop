import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController userPassword = TextEditingController();
  TextEditingController reEnterpass = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool hide = true;
  bool hide1 = true;

  void changePass(String newPass, String confirmPass) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String? jwtToken = preference.getString('jwt');
    String api = "https://shopping-app-backend-t4ay.onrender.com/user/changePassword";
    final Data = {
      "newPass": newPass,
      "confirmPass": confirmPass,
    };
    final Header = {"Authorization": "Bearer $jwtToken"};
    var response = await http.post(Uri.parse(api), body: Data, headers: Header);
    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);
      print(response.statusCode);
      print(responsebody);
      Navigator.pushNamed(context, '/bottoms');
    } else if (response.statusCode == 400) {
      var responsebody = jsonDecode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181a20),
      appBar: AppBar(
        backgroundColor: Color(0xFF181a20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 70, 13, 13),
          child: Align(
            alignment: Alignment.center,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Set New Password',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Password";
                      }
                    },
                    obscureText: hide,
                    controller: userPassword,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF262a34),
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.white38),
                        icon: Icon(
                          Icons.password_outlined,
                          color: Color(0xFF0695b4),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          child: hide
                              ? Icon(
                                  Icons.visibility,
                                  color: Colors.white38,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.white38,
                                ),
                        )),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please re-enter your password';
                      } else if (value != userPassword.text) {
                        return 'Password Not Matching';
                      }
                    },
                    obscureText: hide1,
                    controller: reEnterpass,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF262a34),
                        labelText: 'Re-Enter New Password',
                        labelStyle: TextStyle(color: Colors.white38),
                        icon: Icon(
                          Icons.password_outlined,
                          color: Color(0xFF0695b4),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hide1 = !hide1;
                            });
                          },
                          child: hide1
                              ? Icon(
                                  Icons.visibility,
                                  color: Colors.white38,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.white38,
                                ),
                        )),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 35),
                          primary: Color(0xFF0695b4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            print('add');
                            changePass(userPassword.text, reEnterpass.text);
                          }
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_ordering_system/Screens/Login/Login_Screen.dart';
import 'package:online_ordering_system/validation/validation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/SignUpModel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hide = true;
  bool hide1 = true;
  String? userId;

  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userNumber = TextEditingController();
  TextEditingController userPassword1 = TextEditingController();
  TextEditingController userPassword2 = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void pref(String mail) async {
    SharedPreferences getData = await SharedPreferences.getInstance();
    getData.setString('emailId', mail);
  }

  void fetchData(String name, String mobileNo, String emailId, String password) async {
    String api = 'https://shopping-app-backend-t4ay.onrender.com/user/registerUser';
    final data = {
      "name": name,
      "mobileNo": mobileNo,
      "emailId": emailId,
      "password": password,
    };
    var response = await http.post(Uri.parse(api), body: data);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      userId = responsebody['data']['_id'];
      pref(emailId);
      Navigator.pushNamed(context, '/otp', arguments: userId);
    } else if (response.statusCode == 400) {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181a20),
      body: Padding(
        padding: EdgeInsets.only(top: 80.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                ),
                Text('Create new accunt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                ),
                Text('Please fill in the form to continue',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white38,
                    )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter your Name';
                      } else {
                        return null;
                      }
                    },
                    controller: userName,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF262a34),
                      labelText: 'Full name',
                      labelStyle: TextStyle(color: Colors.white38),
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email address";
                      }
                      if (Validation.validateEmail(value)) {
                        return null;
                      } else {
                        return "Enter a valid email address";
                      }
                    },
                    controller: userEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF262a34),
                      labelText: 'Email address',
                      labelStyle: TextStyle(color: Colors.white38),
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your contact number';
                      } else if (value.length != 10) {
                        return 'please enter valid number';
                      } else
                        return null;
                    },
                    controller: userNumber,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF262a34),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.white38),
                      icon: Icon(
                        Icons.call,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Password";
                      }
                    },
                    obscureText: hide,
                    controller: userPassword1,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF262a34),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white38),
                        icon: Icon(
                          Icons.password_outlined,
                          color: Colors.white38,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please re-enter your password';
                      } else if (value != userPassword1.text) {
                        return 'Password Not Matching';
                      }
                    },
                    obscureText: hide1,
                    controller: userPassword2,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF262a34),
                        labelText: 'Re-Enter Password',
                        labelStyle: TextStyle(color: Colors.white38),
                        icon: Icon(
                          Icons.password_outlined,
                          color: Colors.white38,
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
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      fetchData(userName.text, userNumber.text, userEmail.text, userPassword1.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0695b4),
                    padding: EdgeInsets.fromLTRB(110, 10, 120, 10),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

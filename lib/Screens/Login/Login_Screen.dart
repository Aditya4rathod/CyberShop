import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../../validation/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool hide = true;
  bool isLoading = false;

  void pref(String value, String mail, String contactNo, String name, String valuePass, bool statusvalue) async {
    SharedPreferences getData = await SharedPreferences.getInstance();
    getData.setString('jwt', value);
    getData.setString('emailId', mail);
    getData.setString('mobileNo', contactNo);
    getData.setString('name', name);
    getData.setString('password', valuePass);
    getData.setBool('status', statusvalue);
  }

  void fetchData(String emailId, String password) async {
    var response = await http.post(Uri.parse("https://shopping-app-backend-t4ay.onrender.com/user/login"), body: {
      "emailId": emailId,
      "password": password,
    });
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var jwt = responseBody['data']['jwtToken'];
      print(jwt);
      bool isLogin = responseBody['status'] == 1;
      var name = responseBody['data']['name'];
      var mobileNo = responseBody['data']['mobileNo'];
      pref(jwt, emailId, mobileNo, name, password, isLogin);
      print(response.statusCode);
      print(responseBody);
      Navigator.pushNamed(
        context,
        '/bottoms',
      );
    } else if (response.statusCode == 400) {
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      print(response.statusCode);
      showAlertDialog1(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF181a20),
        body: Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: SingleChildScrollView(
                child: Column(children: [
              Align(
                alignment: Alignment.center,
              ),
              Text('Welcome Back!',
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
              Text('Please Sign in to your account',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white38,
                  )),
              SizedBox(
                height: 60,
              ),
              Form(
                  key: formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(children: [
                        TextFormField(
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
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white38),
                            icon: Icon(
                              Icons.email,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/forgot');
                                },
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(color: Colors.white38),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF0695b4),
                              padding: EdgeInsets.fromLTRB(110, 10, 120, 10),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                fetchData(userEmail.text, userPassword.text);
                              } else {}
                            },
                            child: Text('Sign In')),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t Have an Account ?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                  print('sign in');
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFF0695b4),
                                  ),
                                ))
                          ],
                        )
                      ])))
            ]))));
  }

  showAlertDialog1(BuildContext context) {
    AlertDialog alert = AlertDialog(
        backgroundColor: Color(0xFF262a34),
        title: Text(
          "Login Failed❌",
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          "Invalid username or password!!",
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

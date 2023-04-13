import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_ordering_system/validation/validation.dart';
import 'package:http/http.dart' as http;

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController userEmail = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? userID;

  void fetchData(String emailId) async {
    String api = 'https://shopping-app-backend-t4ay.onrender.com/user/forgotPassword';
    final Data = {
      'emailId': emailId,
    };
    final response = await http.post(Uri.parse(api), body: Data);
    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);
      userID = responsebody['data']['_id'];
      print(response.statusCode);
      print(responsebody);
      Navigator.pushNamed(context, '/forgotpassotp', arguments: userID);
    } else if (response.statusCode == 400) {
      var responsebody = jsonDecode(response.body);
      print(response.statusCode);
      print(responsebody);
    }
  }

  SnackBar snackBar2 = SnackBar(content: Text('Your Account is Not Verify,Kindly Register Again!!', style: TextStyle(color: Colors.red)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF181a20),
        body: Padding(
          padding: EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
              child: Column(children: [
            Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_sharp,
                      color: Colors.white,
                    ))),
            SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.center,
            ),
            Text('Forgot Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Text('Please enter your email we will send you a link to return to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white38,
                  )),
            ),
            SizedBox(
              height: 60,
            ),
            Form(
              key: formKey,
              child: Padding(
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
                      ))),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF0695b4),
                  padding: EdgeInsets.fromLTRB(110, 10, 120, 10),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    fetchData(userEmail.text);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                },
                child: Text('Continue')),
          ])),
        ));
  }
}

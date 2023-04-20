import 'dart:async';
import 'dart:convert';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassOtp extends StatefulWidget {
  const ForgotPassOtp({Key? key}) : super(key: key);

  @override
  State<ForgotPassOtp> createState() => _ForgotPassOtpState();
}

class _ForgotPassOtpState extends State<ForgotPassOtp> {
  late String otpValue;
  String mail = '';

  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
    );
    AccountInfo(context);
  }

  AccountInfo(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      mail = pref.getString('emailId').toString();
    });
  }

  bool changeButton = false;
  String? arguments;

  void fetchData(String userId, String otp) async {
    String api = 'https://shopping-app-backend-t4ay.onrender.com/user/verifyOtpOnForgotPassword';
    final Data = {
      "userId": userId,
      "otp": otp,
    };
    var response = await http.post(Uri.parse(api), body: Data);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      print('$userId');
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 400) {
      var responsebody = jsonDecode(response.body);
    }
  }

  void resendOTP(String userId) async {
    String link = 'https://shopping-app-backend-t4ay.onrender.com/user/resendOtp';
    final Data2 = {
      "userId": userId,
    };
    var response = await http.post(Uri.parse(link), body: Data2);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);
      userId = responsebody['data']['_id'];
      print(responsebody);
      print('$userId');
    } else if (response.statusCode == 400) {
      var responsebody = jsonDecode(response.body);
    }
  }

  SnackBar snackBar2 = SnackBar(content: Text('OTP resend Succesfully!!', style: TextStyle(color: Color(0xFF0695b4))));

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF181a20),
        appBar: AppBar(
          backgroundColor :  Color(0xFF181a20),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context);
            },
            icon: Icon(Icons.arrow_back_sharp,
           ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 100),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Verification Code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'We have sent verification code to your mail',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                OtpTextField(
                  onSubmit: (String value) {
                    otpValue = value;
                  },
                  textStyle: TextStyle(
                    color: Color(0xFF0695b4),
                  ),
                  numberOfFields: 4,
                  showFieldAsBox: true,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  focusedBorderColor: Colors.grey,
                  fieldWidth: 70,
                  borderRadius: BorderRadius.circular(8),
                  borderWidth: 3,
                  cursorColor: Color(0xFF0695b4),
                  filled: true,
                  fillColor: Color(0xFF262a34),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Didn\'t receive the code?',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        resendOTP(arguments.toString());
                        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                      },
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Color(0xFF0695b4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    fetchData(arguments.toString(), otpValue);
                    setState(() {
                      changeButton = true;
                    });
                    Timer(Duration(seconds: 3), () {});
                    // Navigator.pushNamed(context, '/bottoms');
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: changeButton ? 50 : 150,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // shape: changeButton ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
                      color: Color(0xFF0695b4),
                    ),
                    child: changeButton
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
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

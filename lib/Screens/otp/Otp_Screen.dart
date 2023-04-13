import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}
class _OtpScreenState extends State<OtpScreen> {
  String mail = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(
        seconds: 3),
    );
    AccountInfo(context);
  }

  AccountInfo(BuildContext context) async{
    final pref = await SharedPreferences.getInstance();
    setState(() {
      mail = pref.getString('emailId').toString();
    });
  }

  bool changeButton = false;
  late String otpValue;
  String? arguments;

  void fetchData(String userId, String otp) async {
    String api = 'https://shopping-app-backend-t4ay.onrender.com/user/verifyOtpOnRegister';
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
    }
    else if (response.statusCode == 400) {
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
    }
    else if (response.statusCode == 400) {
      var responsebody = jsonDecode(response.body);
    }
  }



  SnackBar snackBar2 = SnackBar(content: Text('OTP resend Succesfully!!', style: TextStyle(color: Color(0xFF0695b4))));


  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF181a20),
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
                SizedBox(height: 15,),
                Text(
                  'We have sent verification code to ${mail}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 18,),
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
                SizedBox(height: 12,),
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
                SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    fetchData(arguments.toString(), otpValue);
                    setState(() {
                      changeButton = true;
                    });
                    Timer(Duration(seconds: 3), () {});
                    // Navigator.pushNamed(context, '/bottoms');
                    showAlertDialog(context);
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
                        ? Icon(Icons.done,
                      color: Colors.white,)
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
                // ElevatedButton(
                //   onPressed: (){
                //       fetchData(arguments.toString(), otpValue.toString());
                //      setState(() {
                //        changeButton = true;
                //      });
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text('Verify'),
                //     ],
                //   ),
                //   style: ElevatedButton.styleFrom(
                //       padding: EdgeInsets.only(top: 15, bottom: 15),
                //       backgroundColor: Color(0xFF0695b4),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       )
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        backgroundColor: Color(0xFF262a34),
        title: Text("OTP verified☑",
          style: TextStyle(
            color: Color(0xFF0695b4),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),),
        content: Text("You Register sucessfully!!",
          style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 15
          ),
        )
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  }

// arguments = ModalRoute.of(context)!.settings.arguments as String;
// print('$arguments');
//   return Scaffold(
//     backgroundColor: Color(0xFF181a20),
//     appBar: AppBar(
//     backgroundColor: Color(0xFF181a20),
//   ),
//     body: SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(15.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text('Verification Code',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 30,
//                   color: Colors.white,
//                 ),),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text('We have sent the code verification to',
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.white38,
//                 ),),
//             ),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                  Text('adityarathod1404@gmail.com',
//                  style: TextStyle(
//                    fontSize: 14,
//                    color: Color(0xFF0695b4),
//                  ),),
//                 IconButton(onPressed: (){
//                   Navigator.pushNamed(context, '/register');
//                 }, icon: Icon(Icons.edit, color: Colors.white70,))
//               ],
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Container(
//               padding: EdgeInsets.all(28),
//               decoration: BoxDecoration(
//                 color: Color(0xFF181a20),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _textFieldOTP(first: true, last: false),
//                       _textFieldOTP(first: false, last: false),
//                       _textFieldOTP(first: false, last: false),
//                       _textFieldOTP(first: false, last: true),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 22,
//                   ),
//                   InkWell(
//                     onTap: (){
//                       fetchData(arguments.toString(), otpValue);
//                       setState(() {
//                         changeButton = true;
//                       });
//                       Timer(Duration(seconds: 3), () {
//                         Navigator.pushNamed(context, '/bottoms');});
//                     // Navigator.pushNamed(context, '/bottoms');
//                        showAlertDialog(context);
//                     },
//                     child: AnimatedContainer(
//                       duration: Duration(seconds: 1),
//                       width: changeButton ? 50 :   150,
//                         height: 50,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                        // shape: changeButton ? BoxShape.circle : BoxShape.rectangle,
//                         borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
//                         color: Color(0xFF0695b4),
//                       ),
//                       child: changeButton
//                           ? Icon(Icons.done,
//                            color: Colors.white,)
//                          : Text(
//                         'Verify',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 25,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 18,
//             ),
//             Text(
//               "Didn't you receive any code?",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white38,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             TextButton(
//               child : Text(
//               "Resend New Code",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF0695b4),
//               )),
//               onPressed: (){
//                 resendOTP(arguments.toString());
//               },
//
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
//
// Widget _textFieldOTP({required bool first , last}) {
//   return Container(
//       width: 60,
//       height: 65,
//       child: AspectRatio(
//         aspectRatio: 1.0,
//         child: TextField(
//             autofocus: true,
//             onChanged: (value) {
//               if (value.length == 1 && last == false) {
//                 FocusScope.of(context).nextFocus();
//               }
//               if (value.length == 0 && first == false) {
//                 FocusScope.of(context).previousFocus();
//               }
//               print(value);
//             },
//             onSubmitted: (value){
//             otpValue = value;
//             },
//             showCursor: false,
//             readOnly: false,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             keyboardType: TextInputType.number,
//             maxLength: 1,
//             decoration: InputDecoration(
//               counter: Offstage(),
//               enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                       width: 3,
//                       color: Colors.white
//                   ),
//                   borderRadius: BorderRadius.circular(12)
//               ),
//             )
//         ),
//       )
//   );
// }
//
// showAlertDialog(BuildContext context) {
//
//   AlertDialog alert = AlertDialog(
//       backgroundColor: Color(0xFF262a34),
//       title: Text("OTP verified☑",
//         style: TextStyle(
//           color: Color(0xFF0695b4),
//           fontSize: 20,
//           fontWeight: FontWeight.w800,
//         ),),
//       content: Text("You Register sucessfully!!",
//         style: TextStyle(
//             color: Colors.white70,
//             fontWeight: FontWeight.w600,
//             fontSize: 15
//         ),
//       )
//   );
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }


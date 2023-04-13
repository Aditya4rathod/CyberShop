import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Register{
  String id;
  String name;
  String mobileNo;
  String emailId;
  int status;
  String jwtToken;
  String fcmToken;
  String createdAt;
  String updatedAt;
  int v;

  Register({
   required this.id,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.status,
    required this.jwtToken,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
 });
}

class RegisterNotifier with ChangeNotifier{
  List<Register> _data = [];

  List<Register> get listData => _data;

}
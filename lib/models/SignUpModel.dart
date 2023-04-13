class SignupModelClass {
  int status;
  String msg;
  SignUpData data;

  SignupModelClass({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SignupModelClass.fromJson(dynamic json) {
    return SignupModelClass(
        status: json['status'] ?? 0, msg: json['msg'] ?? '', data: SignUpData.fromJson(json['data']));
  }
}

class SignUpData {
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

  SignUpData(
      {required this.id,
        required this.name,
        required this.mobileNo,
        required this.emailId,
        required this.status,
        required this.jwtToken,
        required this.fcmToken,
        required this.createdAt,
        required this.updatedAt,
        required this.v});

  factory SignUpData.fromJson(dynamic json) {
    return SignUpData(
      status: json['status'] ?? 0,
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      emailId: json['emailId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      jwtToken: json['jwtToken'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
    );
  }
}
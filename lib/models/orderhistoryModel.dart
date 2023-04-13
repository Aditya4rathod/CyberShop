// To parse this JSON data, do
//
//     final orderedModel = orderedModelFromJson(jsonString);

import 'dart:convert';

OrderedModel orderedModelFromJson(String str) => OrderedModel.fromJson(json.decode(str));

String orderedModelToJson(OrderedModel data) => json.encode(data.toJson());

class OrderedModel {
  OrderedModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  List<Datum> data;

  factory OrderedModel.fromJson(Map<String, dynamic> json) => OrderedModel(
    status: json["status"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.productTotalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String userId;
  String orderId;
  String productId;
  String title;
  String description;
  String price;
  String imageUrl;
  int quantity;
  String productTotalAmount;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"] ?? '',
    userId: json["userId"] ?? '',
    orderId: json["orderId"] ?? '',
    productId: json["productId"],
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    price: json["price"] ?? '',
    imageUrl: json["imageUrl"] ?? '',
    quantity: json["quantity"] ?? 0,
    productTotalAmount: json["productTotalAmount"] ??'',
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "orderId": orderId,
    "productId": productId,
    "title": title,
    "description": description,
    "price": price,
    "imageUrl": imageUrl,
    "quantity": quantity,
    "productTotalAmount": productTotalAmount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

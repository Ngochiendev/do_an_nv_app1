import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Orders{
  String orderID;
  bool checkout;
  double total;
  Timestamp date;
  bool received;
  bool requestCheckOut;
  bool cancelable;
  String tableId;
  Orders({
    @required this.orderID,
    @required this.checkout,
    @required this.total,
    @required this.date,
    @required this.received,
    @required this.requestCheckOut,
    @required this.cancelable,
    @required this.tableId
  });
  factory Orders.fromJson(Map<String, dynamic> json) =>
      Orders(
          orderID: json['orderID'],
          checkout: json['checkout'],
          total: double.parse(json['total'].toString()),
          date: json['date'],
          received: json['received'],
          requestCheckOut: json['requestCheckOut'],
          cancelable: json['cancelable'],
          tableId : json['table']
      );
}
class OrderSnapshot{
  Orders orders;
  DocumentReference reference;
  OrderSnapshot({this.orders, this.reference});

  OrderSnapshot.fromSnapshot(DocumentSnapshot snapshot):
      orders = Orders.fromJson(snapshot.data()),
      reference = snapshot.reference;
}
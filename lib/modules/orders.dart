import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Orders{
  bool checkout;
  int total;
  Timestamp date;
  bool received;
  bool requestCheckOut;
  bool cancelable;
  Orders({
    @required this.checkout,
    @required this.total,
    @required this.date,
    @required this.received,
    @required this.requestCheckOut,
    @required this.cancelable
  });
  factory Orders.fromJson(Map<String, dynamic> json) =>
      Orders(
          checkout: json['checkout'],
          total: json['total'],
          date: json['date'],
          received: json['received'],
          requestCheckOut: json['requestCheckOut'],
          cancelable: json['cancelable']
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Orders{
  String orderID;
  bool checkout;
  double total;
  Timestamp date, receivedTime;
  bool received;
  bool requestCheckOut;
  Timestamp timeRCO; //Request Checkout
  String tableId;
  String waiterRCO;
  String waiterID;
  bool cancelable;
  Orders({
    @required this.orderID,
    @required this.checkout,
    @required this.total,
    @required this.date,
    @required this.received,
    @required this.requestCheckOut,
    @required this.tableId,
    @required this.waiterID,
    @required this.timeRCO,
    @required this.waiterRCO,
    @required this.cancelable,
    @required this.receivedTime
  });
  factory Orders.fromJson(Map<String, dynamic> json) =>
      Orders(
          orderID: json['orderID'],
          checkout: json['checkout'],
          total: double.parse(json['total'].toString()),
          date: json['date'],
          received: json['received'],
          tableId: json['table'],
          requestCheckOut: json['requestCheckOut'],
          waiterID: json['waiterID'],
          waiterRCO: json['waiterRCO'],
          timeRCO:  json['timeRCO'],
          cancelable: json['cancelable'],
          receivedTime: json['receivedTime']
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

class WaitersOrder{
  final String waiterID;
  final String waiterName;
  final Timestamp time;
  final bool check;
  const WaitersOrder({
    @required this.waiterID,
    @required this.waiterName,
    @required this.time,
    @required this.check
  });
  factory WaitersOrder.fromJson(Map<String, dynamic> json) =>
      WaitersOrder(
          waiterID: json['waiterID'],
          waiterName: json['waiterName'],
          time: json['time'],
          check: json['check']
      );
}
class WaitersOrderSnapshot{
  WaitersOrder waitersOrder;
  DocumentReference docs;
  WaitersOrderSnapshot({this.waitersOrder, this.docs});

  WaitersOrderSnapshot.fromSnapshot(DocumentSnapshot snapshot):
        waitersOrder = WaitersOrder.fromJson(snapshot.data()),
        docs = snapshot.reference;
}
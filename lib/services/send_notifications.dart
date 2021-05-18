import 'dart:convert';

import 'package:do_an_nv_app/datas/fake_datas.dart';
import 'package:http/http.dart' as http;

var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

Future<void> sendNotification(String waiterName,String title, String tableNum, String orderID, String type, DateTime date) async{
  Map<String, dynamic> body ={
    "to" : deviceToken,
    "collapse_key" : "type_a",
    "notification" : {
      "body" : "Nhân viên $type : $waiterName",
      "title": "Bàn $tableNum $title"
    },
    "data" : {
      "tableNum" : tableNum,
      "orderID" : orderID,
      "date": date.toString(),
      "type": type
    }
  };
  var response = await http.post(
    url,
    headers: {"Content-type": "application/json",
      "Authorization": "key=AAAAAZL8920:APA91bEi6ArWOfYha7oZK4itXBmkVhSSZGGw0Lo0HX6sDsW1-xPpz-xLpvC4bic2m17wUnELzBNR3w3iIs5Q542nrD71di1OThQst86oYWQhrUKfHrYeMMAgxhVRmIPiMInlrq-QSk57"},
    body: json.encode(body),
  );
}
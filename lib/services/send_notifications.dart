import 'dart:convert';

import 'package:http/http.dart' as http;

var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

Future<void> sendNotification(String waiterName,String title, String tableNum, String orderID, String type) async{
  Map<String, dynamic> body ={
    "to" : "dqA2AfXZSBC2gjp89uz_ns:APA91bGzBfFGrj2NilweqfbTRfUouy0gEQIfVXBmUt5nfDSZz1xtTFT1_-Qf2a5wQ3IJLwaBXiS62sYJQYzvw3h2kzilAW6uA522b1_LLp0r_m6Cy6kLTcNw0KYLWaoC_X2lrBGldAhi",
    "collapse_key" : "type_a",
    "notification" : {
      "body" : "Nhân viên $type : $waiterName",
      "title": "Bàn $tableNum $title"
    },
    "data" : {
      "tableNum" : tableNum,
      "orderID" : orderID,
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
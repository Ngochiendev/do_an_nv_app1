import 'dart:convert';

import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/pages/chat_page.dart';
import 'package:do_an_nv_app/pages/table_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'file:///D:/AndroidStudioProjects/do_an_nv_app/lib/widget/order_item.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:do_an_nv_app/pages/chechout_page.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
class OrderPage extends StatelessWidget {
  int tableNumber;
  String tableID;
  String orderID;
  String waiterName;
  String waiterID;
  OrderPage({@required this.tableNumber});

  static const String routeName = '/OrderPage';
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  Future<void> _sendMessage(String waiterName,String tableNum, String orderID) async{
    Map<String, dynamic> body ={
      "to" : "dqA2AfXZSBC2gjp89uz_ns:APA91bGzBfFGrj2NilweqfbTRfUouy0gEQIfVXBmUt5nfDSZz1xtTFT1_-Qf2a5wQ3IJLwaBXiS62sYJQYzvw3h2kzilAW6uA522b1_LLp0r_m6Cy6kLTcNw0KYLWaoC_X2lrBGldAhi",
      "collapse_key" : "type_a",
      "notification" : {
        "body" : "Nhân viên order: ${waiterName}",
        "title": "Bàn ${tableNumber} có order mới"
      },
      "data" : {
        "tableNum" : tableNum,
        "orderID" : orderID,
        "type": 'order'
      }
    };
    var response = await http.post(
      url,
      headers: {"Content-type": "application/json",
        "Authorization": "key=AAAAAZL8920:APA91bEi6ArWOfYha7oZK4itXBmkVhSSZGGw0Lo0HX6sDsW1-xPpz-xLpvC4bic2m17wUnELzBNR3w3iIs5Q542nrD71di1OThQst86oYWQhrUKfHrYeMMAgxhVRmIPiMInlrq-QSk57"},
      body: json.encode(body),
    );
    // if(response.statusCode == 200 || response.statusCode == 201){
    //   print('Response Body: ${response.body}');
    //   return response;
    // }
    // print('Response Body: ${response.body}');
    // print('Response Status: ${response.statusCode}');
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argument = ModalRoute
        .of(context)
        .settings
        .arguments;
    this.tableNumber = argument['tableNumber'];
    this.orderID = argument['orderID'];
    this.waiterName= argument['waiterName'];
    this.waiterID = argument['waiterID'];
    this.tableID = tableNumber.toString();
    // final cart = Provider.of<Cart>(context);
    final tableOrder = Provider.of<Tables>(context);
    FireStoreDatabaseTables fireStoreDatabaseTables = Provider.of<FireStoreDatabaseTables>(context);
    Cart cart = tableOrder.orderTableList[tableID].order;
    List<CartItem> carts = cart.items.values.toList();
    List<String> productIds = cart.items.keys.toList();
    void _order() async{
      var dateTime = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:sss");
      var timeReq = dateFormat.parse(dateTime.toString());
      tableOrder.addNotification(waiterName, tableID, dateTime, 'order', waiterID, orderID);
      tableOrder.sendOrder(orderID, carts, tableID,waiterName, waiterID,timeReq.toString());
      Navigator.of(context).popUntil((route) => route.settings.name == TablePage.routeName);
      await Future.delayed(Duration(seconds: 1));
      tableOrder.removeOrder(tableNumber.toString());
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Order',
            style: TextStyle(fontSize: 30,
                fontFamily: 'Berkshire Swash',
                fontWeight: FontWeight.bold),),
          centerTitle: true,

        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: Text(tableNumber != 0
                  ? 'Table ${tableNumber} Order'
                  : 'Take away Oder',
                  style: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                      color: Colors.black)),
            ),
            Container(
              height: 450,
              child: carts.length > 0 ? ListView.separated(
                  itemBuilder: (context, item) {
                    if(carts.length!=0) {
                      return OrderItem(
                        tableOrderID: tableID,
                        productID: productIds[item],
                        cartItem: carts[item],
                      );
                    }else return Center(
                      child: Text('Không có đồ uống nào',
                        style: TextStyle(fontSize: 25, color: Colors.grey, fontFamily: 'Pacifico'),),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                  itemCount: cart.items.length) :
                 Center(
                   child:  Text('Chưa có đồ uống nào',
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey, fontFamily: 'Pacifico'),),
                 )
            ),
            Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fact_check_outlined,color: Colors.white,),
                        SizedBox(width: 5,),
                        Text('Xác nhận order', style: TextStyle(fontSize: 15, color: Colors.white),)
                      ],
                    ),
                    onPressed: () {
                        _sendMessage(waiterName, tableID, orderID);
                        _order();
                    },
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, ChatPage.routeName, arguments: {'waiterName': waiterName});
          },
          child: Icon(Icons.message, color: Colors.white,),
        ),
      ),
    );
  }
}
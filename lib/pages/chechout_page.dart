import 'dart:convert';

import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/modules/orders.dart';
import 'package:do_an_nv_app/pages/chat_page.dart';
import 'package:do_an_nv_app/pages/menu_page.dart';
import 'package:do_an_nv_app/pages/table_page.dart';
import 'package:do_an_nv_app/widget/checkout_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
class CheckOutPage extends StatelessWidget {
  int tableNumber;
  String orderID;
  String waiterName;
  String waiterID;
  CheckOutPage({@required this.tableNumber});
  static const String routeName = '/CheckOutPage';
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  Future<void> _sendMessage(String waiterName, String tableNum, String orderID) async{
    Map<String, dynamic> body ={
      "to" : "dqA2AfXZSBC2gjp89uz_ns:APA91bGzBfFGrj2NilweqfbTRfUouy0gEQIfVXBmUt5nfDSZz1xtTFT1_-Qf2a5wQ3IJLwaBXiS62sYJQYzvw3h2kzilAW6uA522b1_LLp0r_m6Cy6kLTcNw0KYLWaoC_X2lrBGldAhi",
      "collapse_key" : "type_a",
      "notification" : {
        "body" : "Nhân viên thanh toán: ${waiterName}",
        "title": "Bàn ${tableNumber} yêu cầu thanh toán"
      },
      "data" : {
        "tableNum" : tableNum,
        "orderID" : orderID,
        "type" : 'checkout'
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
    FireStoreDatabaseTables tables = Provider.of<FireStoreDatabaseTables>(context);
    Map<String, dynamic> argument = ModalRoute
        .of(context)
        .settings
        .arguments;
    this.tableNumber = argument['tableNumber'];
    this.orderID = argument['orderID'];
    this.waiterName = argument['waiterName'];
    this.waiterID = argument['waiterID'];
    String _tableID = tableNumber.toString();
    final tableOrder = Provider.of<Tables>(context);
    return SafeArea(
      child: FutureBuilder(
        future: tables.getOrderDataFromFireBase(orderID, _tableID),
        builder: (context, orderSnapshot){
          if(orderSnapshot.hasData){
            void _cancelOrder() async{
              tableOrder.cancelOrder(_tableID, orderID);
              Navigator.of(context).popUntil(
                      (route) => route.settings.name == TablePage.routeName);
              await Future.delayed(Duration(seconds: 1));
              tableOrder.removeOrder(tableNumber.toString());
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: Text('Thanh Toán',style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Berkshire Swash',
                    fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  orderSnapshot.data.orders.cancelable == true
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: (){
                        _cancelOrder();
                      }
                  ) :
                      Container()

                ],
              ),
              body: StreamBuilder(
                stream: tables.getItemFromFirebase(_tableID, orderID),
                builder: (context,cartItemSnapshot){
                  if(cartItemSnapshot.hasData){
                    // OrderSnapshot snapshot = tables.getOrderDataFromFireBase(orderID, _tableID)
                    void _checkout() async{
                      tableOrder.addNotification(waiterName, _tableID, DateTime.now(), 'checkout', waiterID,orderID);
                      tableOrder.comfirmCheckOut(orderID, _tableID, waiterName, waiterID);
                      Navigator.of(context).popUntil((route) => route.settings.name == TablePage.routeName);
                    }
                    Future<void> showAlert(){
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context){
                            return AlertDialog(
                              title: Text('Bàn đã có thêm order'),
                              content: Text('Đợi thu ngân xác nhận order'),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      Navigator.of(context).popUntil((route) => route.settings.name == MenuPage.routeName);
                                    },
                                    child: Text('Xác Nhận', style: TextStyle(color: Colors.green),)
                                ),
                              ],
                            );
                          }
                      );
                    }
                    if(cartItemSnapshot.data.length == 0){
                      return Center(
                        child: Text('Không có sản phẩm nào', style: TextStyle(fontSize: 20),),
                      );
                    }
                    else{
                      return ListView(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Text(tableNumber != 0
                                    ? 'Hóa đơn bàn: ${tableNumber}'
                                    : 'Hóa đơn mang về',
                                    style: TextStyle(fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Pacifico',
                                        color: Colors.black)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nhân viên:  ${waiterName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 5,),
                                      Text('Mã nhân viên: ${waiterID}',style: TextStyle(fontSize: 14, color: Colors.black54),)
                                    ],
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 350,
                                color: Colors.white,
                                child: ListView.builder(
                                  itemBuilder: (context, index){
                                    CartItem _item = cartItemSnapshot.data[index].cartItem;
                                    // _total+=(_item.price*_item.quantity);
                                    return CheckOutItem(
                                      cartItem: _item,
                                        // id: _tableID,
                                        // productId: _item.id,
                                        // quantity: _item.quantity,
                                        // price: _item.price,
                                        // name: _item.name
                                    );
                                  },
                                  itemCount: cartItemSnapshot.data.length,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Cart total: ', style: TextStyle(fontSize: 18, color: Colors.grey),),
                                        Text('${NumberFormat('###,###','es_US').format(orderSnapshot.data.orders.total)} VNĐ',
                                          style: TextStyle(fontSize: 15, color: Colors.black87),)
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Discount: ', style: TextStyle(fontSize: 18, color: Colors.grey),),
                                        Text('0.0 %',
                                          style: TextStyle(fontSize: 15, color: Colors.black87),)
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Subtotal:',
                                          style: TextStyle(fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Pacifico'),),
                                        Text('${NumberFormat('###,###','es_US').format(orderSnapshot.data.orders.total)} VNĐ',
                                          style: TextStyle(fontSize: 20, color: Colors.red),)
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            color: Colors.blue,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.check,color: Colors.white,),
                                                SizedBox(width: 5,),
                                                Text('Yêu cầu thanh toán', style: TextStyle(fontSize: 15, color: Colors.white),)
                                              ],
                                            ),
                                            onPressed: () async{
                                              if(cartItemSnapshot.data.length == 0){
                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                  content: Text('Chưa có sản phẩm'),
                                                  duration: Duration(seconds: 1),
                                                ));
                                              }
                                              else if(orderSnapshot.data.orders.received==false){
                                                showAlert();
                                              }
                                              else{
                                                _sendMessage(waiterName, _tableID, orderID );
                                                _checkout();
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  Navigator.pushNamed(context, ChatPage.routeName, arguments: {'waiterName': waiterName});
                },
                child: Icon(Icons.message, color: Colors.white,),
              ),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

}

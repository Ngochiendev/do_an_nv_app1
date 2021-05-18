import 'dart:convert';

import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/pages/menu_page.dart';
import 'package:do_an_nv_app/pages/table_page.dart';
import 'package:do_an_nv_app/services/send_notifications.dart';
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

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width/1000;

    FireStoreDatabaseOrders tables = Provider.of<FireStoreDatabaseOrders>(context);
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
        future: tables.getOrderDataFromFireBase(orderID),
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
                stream: tables.getItemCheckOutFromFirebase(orderID),
                builder: (context,cartItemSnapshot){
                  if(cartItemSnapshot.hasData){
                    // OrderSnapshot snapshot = tables.getOrderDataFromFireBase(orderID, _tableID)
                    void _checkout() async{
                      var timeRCO = DateTime.now();
                      tableOrder.addNotification(waiterName, _tableID, DateTime.now(), 'checkout', waiterID,orderID);
                      tableOrder.comfirmCheckOut(orderID, _tableID, waiterName, waiterID, timeRCO);
                      sendNotification(waiterName,'yêu cầu thanh toán', _tableID, orderID, 'checkout', timeRCO);
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
                                      Navigator.of(context).popUntil((route) => route.settings.name == TablePage.routeName);
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
                        child:  Text('Chưa có đồ uống nào',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey, fontFamily: 'Pacifico'),),
                      );
                    }
                    else{
                      return Column(
                        children: [
                          Center(
                            child: Text('Hóa đơn bàn: ${tableNumber}',
                                style: TextStyle(fontSize: size*56,
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
                                  Text('Nhân viên:  ${waiterName}', style: TextStyle(fontSize: size*40, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 5,),
                                  Text('Mã nhân viên: ${waiterID}',style: TextStyle(fontSize: size*35, color: Colors.black54),)
                                ],
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: ListView.builder(
                                itemBuilder: (context, index){
                                  CartItem _item = cartItemSnapshot.data[index].cartItem;
                                  // _total+=(_item.price*_item.quantity);
                                  return CheckOutItem(
                                    cartItem: _item,
                                  );
                                },
                                itemCount: cartItemSnapshot.data.length,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cart total: ', style: TextStyle(fontSize: size*43, color: Colors.grey),),
                                    Text('${NumberFormat('###,###','es_US').format(orderSnapshot.data.orders.total)} VNĐ',
                                      style: TextStyle(fontSize: size*38, color: Colors.black87),)
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discount: ', style: TextStyle(fontSize: size*43, color: Colors.grey),),
                                    Text('0.0 %',
                                      style: TextStyle(fontSize: size*38, color: Colors.black87),)
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
                                      style: TextStyle(fontSize: size*55,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Pacifico'),),
                                    Text('${NumberFormat('###,###','es_US').format(orderSnapshot.data.orders.total)} VNĐ',
                                      style: TextStyle(fontSize: size*45, color: Colors.red),)
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

                                            _checkout();
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

}

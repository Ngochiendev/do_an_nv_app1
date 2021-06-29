import 'dart:convert';

import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/pages/table_page.dart';
import 'package:do_an_nv_app/services/send_notifications.dart';
import 'package:do_an_nv_app/widget/order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/modules/tables.dart';
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
  final animationKey = GlobalKey<AnimatedListState>();
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
    final tableOrder = Provider.of<Tables>(context);
    Cart cart = tableOrder.orderTableList[tableID].order;
    List<CartItem> cartItems = cart.items.values.toList();
    List<String> productIds = cart.items.keys.toList();
    void _order() async{
      var dateTime = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:sss");
      // var timeReq = dateFormat.parse(dateTime.toString());
      await tableOrder.addNotification(waiterName, tableID, dateTime, 'order', waiterID, orderID);
      await tableOrder.sendOrder(orderID, cartItems, tableID,waiterName, waiterID, dateTime);
      sendNotification(waiterName,'có order mới', tableID, orderID, 'order', dateTime);
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
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
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
              Expanded(
                child: cartItems.length > 0 ?
                ListView.builder(
                    itemBuilder: (context, itemIndex) {
                      if(cartItems.length!=0) {
                        return OrderItem(
                            cartItem: cartItems[itemIndex],
                            tableOrderID: tableID,
                            productID: productIds[itemIndex],
                        );
                      }else return Center(
                        child: Text('Không có đồ uống nào',
                          style: TextStyle(fontSize: 25, color: Colors.grey, fontFamily: 'Pacifico'),),
                      );
                    },

                   itemCount: cart.items.length,
                ) :
                Center(
                  child:  Text('Chưa có đồ uống nào',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey, fontFamily: 'Pacifico'),),
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              SizedBox(height: 10,),

              // Confirm Order Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: cartItems.length > 0 ? Row(
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
                        _order();
                      },
                    )
                  ],
                )
                    : SizedBox()
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );

  }

  // Widget _builItem(CartItem cartItem, String tableID, String productID, int index, Animation<double> animation ){
  //   return OrderItem(
  //     animation: animation,
  //     tableOrderID: tableID,
  //     cartItem: cartItem,
  //     productID: productID,
  //     callback: (cartItemRemove, productIDRemove) => removeItem(index, cartItemRemove, productIDRemove) ,
  //   );
  // }
  //
  // void removeItem(int index, CartItem cartItem, String productID){
  //   animationKey.currentState.removeItem(index, (context, animation) =>
  //     _builItem(cartItem, tableID, productID, index, animation), duration: Duration(milliseconds: 500),
  //   );
  // }
}
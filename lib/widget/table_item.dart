import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/modules/orders.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:do_an_nv_app/pages/menu_page.dart';
import 'package:do_an_nv_app/datas/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
class TableItem extends StatelessWidget {
  int tableNum;
  String waiterName;
  String waiterID;
  bool requestCheckOut;
  bool received;
  bool checkout;
  String orderID;
  TableItem({
    this.orderID,
    @required this.tableNum,
    @required this.waiterName,
    @required this.waiterID,
    this.requestCheckOut,
    this.received,
    @required this.checkout
  });
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseOrders orders = Provider.of<FireStoreDatabaseOrders>(context);
    final tableOrder = Provider.of<Tables>(context);
    if(checkout) {
      return InkWell(
        onTap: (){
          DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:sss");
          var orderTime = dateFormat.parse(DateTime.now().toString());
          tableOrder.addOrderInTable(tableNum.toString(), new Cart());
          orders.addOrderToFirebase(tableNum.toString(), orderTime);
          Navigator.pushNamed(context, MenuPage.routeName,
              arguments: {
                'tableNumber': tableNum,
                'orderID': tableNum.toString()+orderTime.toString(),
                'waiterName': waiterName,
                'waiterID': waiterID
              });
        },
        splashColor: Colors.deepPurple,
        child: Container(
          child: Center(
            child: Text('Table $tableNum',style: TextStyle(fontSize: 15,fontFamily: 'Pacifico', color: Colors.white),),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.black54.withOpacity(0.3),
                    Colors.black54
                  ],
                  end: Alignment.bottomLeft,
                  begin: Alignment.topRight
              ),
              borderRadius: BorderRadius.circular(15)
          ),
        ),
      );
    }
    else{
      if(received) {
        return InkWell(
          onTap: (){
            tableOrder.addOrderInTable(tableNum.toString(), new Cart());
            Navigator.pushNamed(context, MenuPage.routeName,
                arguments: {
                  'tableNumber': tableNum,
                  'orderID': orderID,
                  'waiterName': waiterName,
                  'waiterID': waiterID
                });
          },
          splashColor: Colors.deepPurple,
          child: Container(
            child: Center(
              child: Text('Table ${tableNum}',style: TextStyle(fontSize: 15,fontFamily: 'Pacifico', color: Colors.white),),
            ),
            decoration: BoxDecoration(
                color: requestCheckOut ? Colors.lightGreenAccent : Colors.green,
                borderRadius: BorderRadius.circular(15)
            ),
          ),
        );
      }
      else{
        return InkWell(
          onTap: (){
            tableOrder.addOrderInTable(tableNum.toString(), new Cart());
            Navigator.pushNamed(context, MenuPage.routeName,
                arguments: {
                  'tableNumber': tableNum,
                  'orderID': orderID,
                  'waiterName': waiterName,
                  'waiterID': waiterID
                });
          },
          splashColor: Colors.deepPurple,
          child: Container(
            child: Center(
              child: Text('Table ${tableNum}',style: TextStyle(fontSize: 15,fontFamily: 'Pacifico', color: Colors.white),),
            ),
            decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(15)
            ),
          ),
        );
      }
    }

  }
}

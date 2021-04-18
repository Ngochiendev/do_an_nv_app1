import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/modules/orders.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:do_an_nv_app/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class TableItem extends StatelessWidget {
  int tableNum;
  String waiterName;
  String waiterID;
  TableItem({@required this.tableNum, @required this.waiterName, @required this.waiterID});
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseTables tables = Provider.of<FireStoreDatabaseTables>(context);
    final tableOrder = Provider.of<Tables>(context);
    return StreamBuilder<List<OrderSnapshot>>(
      stream: tables.getAllOrderFromFireBase(tableNum.toString()),
      builder: (context,snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length != 0 && snapshot.data.first.orders.checkout == false){
            if(snapshot.data.first.orders.received==false){
              return InkWell(
                onTap: (){
                  tableOrder.addOrderInTable(tableNum.toString(), new Cart());
                  String orderID = tableNum.toString()+snapshot.data.first.orders.date.toDate().toString();
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
            else{
              return InkWell(
                onTap: (){
                  tableOrder.addOrderInTable(tableNum.toString(), new Cart());
                  String orderID = tableNum.toString()+snapshot.data.first.orders.date.toDate().toString();
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
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(15)
                  ),
                ),
              );
            }
          }
          else{
            return InkWell(
              onTap: (){
                DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:sss");
                var orderTime = dateFormat.parse(DateTime.now().toString());
                tableOrder.addOrderInTable(tableNum.toString(), new Cart());
                tables.addOrderToFirebase(tableNum.toString(), orderTime);
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
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

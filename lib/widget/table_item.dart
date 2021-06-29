import 'package:cloud_firestore/cloud_firestore.dart';
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
  Timestamp timeRCO;
  String waiterRCO;
  Timestamp date,receivedTime;
  TableItem({
    this.orderID,
    @required this.tableNum,
    @required this.waiterName,
    @required this.waiterID,
    this.requestCheckOut,
    this.received,
    @required this.checkout,
    this.date,
    this.receivedTime,
    this.timeRCO,
    this.waiterRCO
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
      return StreamBuilder<List<WaitersOrderSnapshot>>(
        stream: orders.getWaitersFromFirebase(orderID),
        builder: (context, waitersOrderSnapshot){
          if(waitersOrderSnapshot.hasData){

            // List All waiter order
            List<WaitersOrderSnapshot> listWaiter = waitersOrderSnapshot.data;

            // List All waiter order name
            List<String> listWaiterName = listWaiter.map((data){
              return data.waitersOrder.waiterName;
            }).toList();

            // List waiter hasn't check
            List<WaitersOrderSnapshot> listWaiterNotCheck = waitersOrderSnapshot.data
                .where((element) => element.waitersOrder.check == false)
                .toList();

            //Show info table
            Future<void> _showInfo(){
              // String dateString = date.toDate().toString();
              // DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateString);
              DateFormat dateFormatInfoTime = DateFormat('MMM dd hh:mm:ss aa');
              String checkInTime = dateFormatInfoTime.format(date.toDate());
              // String receivedTimeString = DateFormat('MMMM d yyyy hh:mm:ss aa').format(receivedTime.toDate());
              double normalTextFont = 16;
              return showDialog<void>(
                context: context,
                builder: (BuildContext context) {

                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amberAccent,size: 35,),
                        SizedBox(width: 5,),
                        Text('Thông tin bàn $tableNum',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                      ],
                    ),
                    contentPadding: EdgeInsets.all(15).copyWith(right: 20),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: 5,),
                              Text('Thời gian vào: ', style: TextStyle(fontSize: normalTextFont)),
                              SizedBox(width: 2,),
                              Text(checkInTime,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: normalTextFont-1))
                            ],
                          ),
                          SizedBox(height: 5,),
                          listWaiter.length == 0
                              ? SizedBox()
                              : Row(
                            children: [
                              SizedBox(width: 5,),
                              Text('Thời gian order: ', style: TextStyle(fontSize: normalTextFont)),
                              SizedBox(width: 2,),
                              Text(dateFormatInfoTime.format(listWaiter.first.waitersOrder.time.toDate()),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: normalTextFont-1))
                            ],
                          ),

                          SizedBox(height: 5,),
                          listWaiter.length == 0 ?
                              Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Text('Khách đang gọi nước ', style: TextStyle(fontSize: normalTextFont),),
                                ],
                              )
                              :Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 5,),
                              Text('Nhân viên order: ', style: TextStyle(fontSize: normalTextFont),),
                              SizedBox(width: 2,),
                              Expanded(
                                  child: Text(listWaiterName.join(', '),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: normalTextFont-1))
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          received
                              ? Row(
                                  children: [
                                    SizedBox(width: 5,),
                                    Text('Thời gian xác nhận: ', style: TextStyle(fontSize: normalTextFont)),
                                    SizedBox(width: 2,),
                                    Text(dateFormatInfoTime.format(receivedTime.toDate()),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: normalTextFont-1))
                                  ],
                              )
                              : SizedBox(),
                          SizedBox(height: 5,),
                          timeRCO == null
                              ? SizedBox()
                              : Row(
                            children: [
                              SizedBox(width: 5,),
                              Text('Thời gian checkout: ', style: TextStyle(fontSize: normalTextFont)),
                              SizedBox(width: 2,),
                              Text(dateFormatInfoTime.format(timeRCO.toDate()),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: normalTextFont-1))
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[

                      TextButton(
                        child: Text('Xác nhận', style: TextStyle(color: Colors.green, fontSize: 18),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
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
                onLongPress: (){
                    _showInfo();
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
                onLongPress: (){
                  _showInfo();
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
          return Center(child: CircularProgressIndicator(),);
        },
      );
    }

  }
}

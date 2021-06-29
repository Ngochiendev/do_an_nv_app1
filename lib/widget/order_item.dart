
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:intl/intl.dart';

typedef void MyCallBack(CartItem cartItem, String productID);
class OrderItem extends StatelessWidget {
  final String tableOrderID; // Id cua Map tableOrderList
  final CartItem cartItem;
  // final Animation animation;
  final String productID;
  // final MyCallBack callback;
  OrderItem({
    @required this.tableOrderID,
    @required this.cartItem,
    @required this.productID,
    // @required this.animation,
    // @required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width/1000;
    final tableOrder = Provider.of<Tables>(context);
    final radius = Radius.circular(5);
    final borderRadius = BorderRadius.all(radius);
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        // callback(cartItem, productID);
        tableOrder.removeItemInOrder(tableOrderID, productID);
      },
      background:
      Container(
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.only(right: 50),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.red,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white, size: 23,),
                    Text('Xóa', style: TextStyle(fontSize: 18, color: Colors.white),)
                  ],
                )
              ]
          )
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(left: 10,top: 10, bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: borderRadius,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(1,2),
                  color: Colors.black26,
                  blurRadius: 2.0
              )
            ]
        ),
        child:  Row(
          children: [
            Container(
              width: 40.0,
              height: 75.0,
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      tableOrder.addQuantityItemInOrder(tableOrderID, productID);
                    },
                    child: Icon(Icons.keyboard_arrow_up_sharp),
                  ),
                  Text('${cartItem.quantity}', style: TextStyle(fontSize: size*43),),
                  InkWell(
                    onTap: (){
                      if(cartItem.quantity>1){
                        tableOrder.removeSingleItemInOrder(tableOrderID, productID);
                      }
                    },
                    child: Icon(Icons.keyboard_arrow_down_sharp),

                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(cartItem.image),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(70.0),
                  boxShadow:  [
                    BoxShadow(
                        offset: Offset(2,4),
                        color: Colors.black45,
                        blurRadius: 4.0
                    )
                  ]

              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${cartItem.name}', style: TextStyle(fontSize: size*48, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.red,),
                      Text('${NumberFormat('###,###','es_US').format(cartItem.price)} VNĐ', style: TextStyle(fontSize: size*36, color: Colors.red),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(Icons.announcement,color: Colors.deepOrangeAccent,),
                      Container(
                        height: 20,
                        width: 160,
                        child: ListView(
                          children: [
                            Text('${cartItem.note}',style: TextStyle(fontSize: size*36,))
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            // Nut xoa
            // Center(
            //   child: IconButton(
            //     icon: Icon(Icons.remove_circle_outline),
            //     tooltip: 'Remove Item',
            //     onPressed: (){
            //       callback(cartItem, productID);
            //       tableOrder.removeItemInOrder(tableOrderID, productID);
            //     },
            //   ),
            // )

          ],
        ),
      ),

    );
    //   SlideTransition(
    //   position: Tween<Offset>(
    //     begin: Offset(-1,0),
    //     end: Offset(0, 0),
    //   ).animate(CurvedAnimation(
    //     parent: animation,
    //     curve: Curves.easeIn,
    //     reverseCurve: Curves.easeIn
    //   )),
    //   child:
    // );
  }

}



import 'package:do_an_nv_app/modules/beverages.dart';
import 'package:do_an_nv_app/pages/beverage_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:intl/intl.dart';
class BeverageItemPage extends StatelessWidget {
  String orderID;
  TextEditingController _noteController = TextEditingController();
  Beverages beverages;
  BeverageItemPage({
    @required this.beverages,
    @required this.orderID
});
  @override
  Widget build(BuildContext context) {
    final tableOrder = Provider.of<Tables>(context);
    void _onButtonShowModalSheet(){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                Column(
                  children: [
                    SizedBox(height: 10,),
                    TextField(
                      maxLines: null,
                      // expands: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        labelText: 'Thêm ghi chú',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.comment),
                      ),
                      controller: _noteController,
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_shopping_cart_outlined,color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Text('Thêm vào giỏ', style: TextStyle(fontSize: 15, color: Colors.white),)
                                ],
                              ),
                              onPressed:(){
                                tableOrder.addItemInOrder(orderID,
                                    beverages.id,
                                    beverages.name,
                                    beverages.price,
                                    _noteController.text,
                                    beverages.image
                                );
                                // Scaffold.of(context).showSnackBar(SnackBar(
                                //   content: Text('Add item to cart'),
                                //   duration: Duration(seconds: 1),
                                // ));
                                // tableOrder.addOrderInTable(orderID, new Cart());
                                // tableOrder.addItemInOrder(orderID,
                                //     beverages.id,
                                //     beverages.name,
                                //     beverages.price,
                                //     _noteController.text);
                                Navigator.of(context).pop();
                              }
                            )
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            color: Colors.grey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel_outlined,color: Colors.white),
                                SizedBox(width: 5,),
                                Text('Hủy bỏ', style: TextStyle(fontSize: 15, color: Colors.white),)
                              ],
                            ),
                            onPressed:() {
                              Navigator.of(context).pop();
                            }
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            );
          }
      );
    }
    return Slidable(
        child: ListTile(
          leading: Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/${beverages.image}'),
                fit: BoxFit.contain
              )
            ),
          ),
          title: Text(beverages.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
          isThreeLine: true,
          subtitle: Container(
            width: 180,
            height: 55,
            child: ListView(
              children: [
                Text(beverages.description, style: TextStyle(fontSize: 15,),),
              ],
            ),
          ),
          trailing: Text('${NumberFormat('###,###','es_US').format(beverages.price)} VNĐ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),),
        ),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
     secondaryActions: [
       IconSlideAction(
         caption: 'Thêm',
         color: Colors.red,
         icon: Icons.add_shopping_cart_outlined,
         onTap: (){
           Scaffold.of(context).showSnackBar(SnackBar(
             content: Text('Add item to cart'),
             duration: Duration(seconds: 1),
           ));
           tableOrder.addItemInOrder(orderID,
               beverages.id,
               beverages.name,
               beverages.price,
               'Không có ghi chú',
               beverages.image
           );
            
         },
       ),
       IconSlideAction(
         caption: 'Chi tiết',
         color: Colors.amberAccent,
         icon: Icons.info_outline,
         onTap: (){
           Navigator.pushNamed(context, BeverageDetailPage.routeName, arguments: {'Beverage': beverages});
         },
       ),
       IconSlideAction(
         caption: 'Dặn dò',
         color: Colors.blue,
         icon: Icons.announcement,
         onTap: (){
            _onButtonShowModalSheet();
         },
       ),
     ],
    );
  }

}

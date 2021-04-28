import 'package:do_an_nv_app/modules/beverages.dart';
import 'package:do_an_nv_app/pages/beverage_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
class BeverageItemPage extends StatelessWidget {
  String orderIdInCode;
  TextEditingController _noteController = TextEditingController();
  Beverages beverages;
  BeverageItemPage({
    @required this.beverages,
    @required this.orderIdInCode
});
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width/1000;
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
                                tableOrder.addItemInOrderWithNote(orderIdInCode,
                                    beverages,
                                    _noteController.text
                                );
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
            child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: beverages.image,
                fit: BoxFit.cover,
            )
          ),
          title: Text(beverages.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: size*50,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange
            ),
          ),
          isThreeLine: true,
          subtitle: Container(
            width: 220,
            height: 55,
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                // Row(
                //   children: [
                //     Icon(Icons.description_outlined, color: Colors.orange, size: 15,),
                //     SizedBox(width: 5,),
                //     Text('Mô tả:', style: TextStyle(
                //       fontSize: 15, color: Colors.orange
                //     ),)
                //   ],
                // ),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      // WidgetSpan(child: Icon(Icons.description_outlined, color: Colors.orange, size: 14,),),
                      WidgetSpan(child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Mô tả:',
                            style: TextStyle(
                                fontSize: size*42,
                                color: Colors.orange,
                                decoration: TextDecoration.underline
                        ),),
                      )),
                      TextSpan(text: beverages.description,
                        style: TextStyle(fontSize: size*40,),),

                    ]
                  ),
                )
              ],
            )
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${NumberFormat('###,###','es_US').format(beverages.price)} VNĐ',
                style: TextStyle(fontSize: size*40, fontWeight: FontWeight.bold, color: Colors.red),),
            ],
          )
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
           tableOrder.addItemInOrder(orderIdInCode, beverages);
         },
       ),
       IconSlideAction(
         caption: 'Chi tiết',
         color: Colors.amberAccent,
         icon: Icons.info_outline,
         onTap: (){
           Navigator.pushNamed(context, BeverageDetailPage.routeName, arguments: {'Beverage': beverages, 'orderIdInCode': orderIdInCode});
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

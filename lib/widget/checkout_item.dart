import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
class CheckOutItem extends StatelessWidget {
  final CartItem cartItem;
  CheckOutItem({
    @required this.cartItem
  });
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width/1000;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          // border: Border.all(width: 1, color: Colors.grey),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //       offset: Offset(1,2),
          //       color: Colors.black26,
          //       blurRadius: 2.0
          //   )
          // ]
      ),
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                boxShadow:  [
                  BoxShadow(
                      offset: Offset(2,4),
                      color: Colors.black45,
                      blurRadius: 4.0
                  )
                ]
            ),
            child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: cartItem.image,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cartItem.name, style: TextStyle(fontSize: size*50, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 5,),
                Text('Số lương: ${cartItem.quantity}',style: TextStyle(fontSize: size*40, fontWeight: FontWeight.bold, color: Colors.grey),)
              ],
            ),
          ),
          Text('\$: ${NumberFormat('###,###','es_US').format(cartItem.quantity*cartItem.price)} VNĐ', style: TextStyle(fontSize: size*40, color: Colors.green),)
        ],
      ),
    );
  }
}

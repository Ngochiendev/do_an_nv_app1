import 'package:do_an_nv_app/modules/beverages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class BeverageDetailPage extends StatelessWidget {
  static const String routeName = '/BeverageDetailPage';
  Beverages beverages;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argument = ModalRoute.of(context).settings.arguments;
    this.beverages = argument['Beverage'];
    final radius = Radius.circular(20);
    return Scaffold(
      backgroundColor: Colors.green,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            // Heading
            Container(
              height: 60,
              padding: EdgeInsets.all(12).copyWith(left: 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_backspace_outlined, color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text('Chi Tiết Đồ Uống',
                    style: TextStyle(fontSize: 23,color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Berkshire Swash'),)
                ],
              ),
            ),
            SizedBox(height: 130,),
            Expanded(
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.favorite_border_rounded, size: 30,),
                            Icon(Icons.add_shopping_cart,size: 30, color: Colors.red,)
                          ],
                        ),
                        SizedBox(height: 25,),
                        Text(beverages.name,
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green, fontFamily: 'Pacifico'),),
                        Text('Mô Tả:',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange, fontFamily: 'Pacifico'),),
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              height: 200,
                              padding: EdgeInsets.all(30),
                              child: ListView(
                                children: [
                                  Text('${beverages.description}',
                                    style: TextStyle(fontSize: 20, color: Colors.black),)
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 5,
                              child: Text('"', style: TextStyle(fontSize: 40, fontFamily: 'Pacifico'),),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 10,
                              child: Text('"', style: TextStyle(fontSize: 40, fontFamily: 'Pacifico'),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.monetization_on_sharp, color: Colors.deepOrange,),
                                Text('Giá: ',
                                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, fontFamily: 'Pacifico' ,color: Colors.deepOrange),),
                              ],
                            ),
                            Text('${NumberFormat('###,###','es_US').format(beverages.price)} VNĐ',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))

                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned.fill(
                    top: -130,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width:  250 ,
                        height: 250*3/4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 2, color: Colors.black),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 10,
                                  offset: Offset(0,5)
                              )
                            ],
                            image: DecorationImage(
                                image: AssetImage('assets/images/${beverages.image}'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    )
                  )
                ],
              )
            )
            //Body


          ],
        ),
      ),
    );
  }
}

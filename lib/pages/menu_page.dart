import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/pages/chat_page.dart';
import 'package:do_an_nv_app/pages/order_page.dart';
import 'package:do_an_nv_app/widget/beverage_item.dart';
import 'package:do_an_nv_app/widget/catagory_section.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:do_an_nv_app/modules/beverages.dart';
import 'package:provider/provider.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:do_an_nv_app/pages/chechout_page.dart';

class MenuPage extends StatefulWidget {
  static const String routeName = '/MenuPage';
  int tableNumber;
  String orderID;
  String waiterName;
  String waiterID;
  MenuPage({@required this.tableNumber});
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  List<BeverageSnapshot> beverages;
  List<BeverageSnapshot> beveragesDisplay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width/1000;
    FireStoreDatabaseBeverage fireStoreDatabaseBeverage = Provider.of<FireStoreDatabaseBeverage>(context);
    // FireStoreDatabaseTables fireStoreDatabaseTables = Provider.of<FireStoreDatabaseTables>(context);
    // final tableOrder = Provider.of<Tables>(context);
    // final tableOrder = Provider.of<Tables>(context);
    Map<String, dynamic> argument = ModalRoute.of(context).settings.arguments;
    this.widget.tableNumber = argument['tableNumber'];
    this.widget.orderID = argument['orderID'];
    this.widget.waiterName = argument['waiterName'];
    this.widget.waiterID = argument['waiterID'];
    String _tableID = widget.tableNumber.toString();
    String catagoryID = '';

        return StreamBuilder<List<BeverageSnapshot>> (
            stream: fireStoreDatabaseBeverage.getBeverageFromFireBase(),
            builder: (context, snapshot){
              // beverages = snapshot.data;
              if(snapshot.hasData){
                return SafeArea(
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: AppBar(
                        backgroundColor: Colors.green,
                        title: Text(widget.tableNumber != 0 ? 'Table ${widget.tableNumber}' : 'Take away',
                            style: TextStyle(fontSize: 30, fontFamily: 'Berkshire Swash', fontWeight: FontWeight.bold)),
                        actions: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(icon: const Icon(
                                Icons.shopping_cart_sharp,color: Colors.white, size: 30,),
                                  onPressed: (){
                                    Navigator.pushNamed(context, OrderPage.routeName,
                                        arguments: {
                                          'tableNumber': widget.tableNumber,
                                          'orderID': widget.orderID,
                                          'waiterID': widget.waiterID,
                                          'waiterName': widget.waiterName
                                        });
                                  }),
                              Positioned(
                                top: 10,
                                right: 15,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.red,

                                    ),
                                    alignment: Alignment.center,
                                    width: 15,
                                    height: 15,
                                    child: Consumer<Tables>(
                                      builder: (context, tableOrder, child){
                                        return Text('${tableOrder.coutItemInOrder(_tableID)}',
                                          style: TextStyle(fontSize: size*25, fontWeight: FontWeight.bold, color: Colors.white),);
                                      },
                                    )
                                ),
                              )
                            ],
                          ),
                          IconButton(icon: Icon(FontAwesomeIcons.fileInvoiceDollar),
                              onPressed: (){
                                Navigator.pushNamed(context, CheckOutPage.routeName,
                                    arguments: {
                                      'tableNumber': widget.tableNumber,
                                      'orderID': widget.orderID,
                                      'waiterID': widget.waiterID,
                                      'waiterName': widget.waiterName
                                    });
                              })
                        ],
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          onPressed: (){
                            Navigator.of(context).pop();
                            // fireStoreDatabaseTables.cancelOrder(_tableID, widget.orderID);
                            // tableOrder.removeOrder(_tableID);
                          },
                        ),
                      ),
                      body: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 10),
                            child: Center(child: Text('Danh mục',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black45),),),),
                          CatagorySection(voidCallback: (catagoryId){
                            setState(() {
                              if (catagoryID == catagoryId) {
                                beverages = snapshot.data;
                                beveragesDisplay = beverages;
                                catagoryID = '';
                              } else {
                                catagoryID = catagoryId;
                                beverages = snapshot.data.where((data) => data.beverages.catagoryId == catagoryID).toList();
                                beveragesDisplay = beverages;
                              }
                            });
                          },),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              onChanged: (text){
                                text = text.toLowerCase();
                                setState(() {
                                  if(beverages == null){
                                    beveragesDisplay = snapshot.data.where((docs){
                                      var beverageName = docs.beverages.name.toLowerCase();
                                      return beverageName.contains(text);
                                    }).toList();
                                  }
                                  else{
                                    beveragesDisplay = beverages.where((data){
                                      var beverageName = data.beverages.name.toLowerCase();
                                      return beverageName.contains(text);
                                    }).toList();
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                labelText: 'Tìm kiếm đồ uống',
                                prefixIcon: Icon(Icons.search),

                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: ListView.separated(
                                    itemBuilder: (context, beverageID) {
                                      Beverages _beverage = beveragesDisplay==null ? snapshot.data[beverageID].beverages : beveragesDisplay[beverageID].beverages;
                                      return BeverageItemPage(beverages: _beverage,orderIdInCode: widget.tableNumber.toString(),);
                                    },
                                    separatorBuilder: (context, index) => Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                    itemCount: beveragesDisplay==null ? snapshot.data.length : beveragesDisplay.length
                                )
                            ),
                          )
                        ],
                      ),
                    )
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );


  }

}


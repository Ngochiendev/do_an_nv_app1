import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_nv_app/modules/employes.dart';
import 'package:do_an_nv_app/pages/chat_page.dart';
import 'package:do_an_nv_app/widget/table_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  static const String routeName = '/TablePage';
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  Employes employee;
  bool _initialized = false;
  bool _error = false;
  bool _hadMessage = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void  _getToken(){
    _firebaseMessaging.getToken().then((deviceToken) {
      if(deviceToken!=null){
        FirebaseFirestore.instance.collection('tokens')
            .doc(deviceToken).set({
          'deviceToken': deviceToken
        });
      }
    });
  }
  _configureFirebaseMessaging(){
    _firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {

      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Message data: ${message.data}');
      if(message.data['type'] == 'messages'){
        setState(() {
          _hadMessage = true;
        });
      }

    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published: ${message}');
      Navigator.pushNamed(context, ChatPage.routeName, arguments: {'employee': employee,});
    });
  }


  void initializedFirebase() async {
    try{
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    }catch(e){
      _error = true;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _configureFirebaseMessaging();
    initializedFirebase();
    _getToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argument = ModalRoute.of(context).settings.arguments;
     employee = argument['employee'];
    if(_error){
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "Lỗi kết nối",
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.ltr,
          ),
        ),
      );
    }
    else{
      if(_initialized){
        return WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.green,
                    title: Center(
                      child: Text('Table',
                        style: TextStyle(fontSize: 30, fontFamily: 'Berkshire Swash', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // actions: <Widget>[
                    //   IconButton(icon: const Icon(
                    //       Icons.agriculture_rounded, size: 30),
                    //       onPressed: (){
                    //         // var orderTime = DateTime.now();
                    //         // String tableID = '0';
                    //         // tableOrder.addOrderInTable(tableID, new Cart(), orderTime);
                    //         // Navigator.pushNamed(context, MenuPage.routeName, arguments: {'tableNumber': 0, 'orderID': tableID+orderTime.toString()});
                    //       })
                    // ],
                  ),
                  body: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3/2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: 15,
                    itemBuilder: (context, index){
                      return TableItem(tableNum: index+1, waiterName: employee.name, waiterID: employee.id,);
                    },
                  ),
                  drawer: Drawer(
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.account_circle, size: 50,),
                              SizedBox(width: 20,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(employee.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(employee.id,style: TextStyle(fontSize: 15, color: Colors.black54),)
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Đăng xuất'),
                          onTap: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: Stack(
                    children: [
                      FloatingActionButton(
                        onPressed: (){
                          Navigator.pushNamed(context, ChatPage.routeName,  arguments: {'employee': employee});
                          setState(() {
                            _hadMessage = false;
                          });
                        },
                        child:  Icon(Icons.message, color: Colors.white,),
                      ),
                      _hadMessage == false ? Positioned(top: 0,right: 0,child: Container(),)
                          : Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          alignment: Alignment.center,
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red
                          ),
                          child: Text('N', style: TextStyle(fontSize: 12, color: Colors.white),),
                        ),
                      )
                    ],
                  ),
              )
          ),
        );
      }
      else {
        return Container(
          color: Colors.white,
          child: Center(
            child: Text(
              "Đang kết nối",
              style: TextStyle(fontSize: 16),
              textDirection: TextDirection.ltr,
            ),
          ),
        );
      }
    }

  }
}

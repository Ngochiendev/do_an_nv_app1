import 'package:do_an_nv_app/datas/chat_data.dart';
import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/pages/beverage_detail_page.dart';
import 'package:do_an_nv_app/pages/chat_page.dart';
import 'package:do_an_nv_app/pages/identify_page.dart';
import 'package:do_an_nv_app/pages/menu_page.dart';
import 'package:do_an_nv_app/pages/order_page.dart';
import 'package:do_an_nv_app/pages/table_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'pages/table_page.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/modules/tables.dart';
import 'package:do_an_nv_app/pages/chechout_page.dart';


Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
const AndroidNotificationChannel  channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Tables(),
        ),
        Provider<FireStoreDatabaseCatagory>(create: (context)=> FireStoreDatabaseCatagory()),
        Provider<FireStoreDatabaseBeverage>(create: (context) => FireStoreDatabaseBeverage()),
        Provider<FireStoreDatabaseMessage>(create: (context) => FireStoreDatabaseMessage()),
        Provider<FireStoreDatabaseTables>(create: (context) => FireStoreDatabaseTables())
      ],
      child: MaterialApp(
        title: 'CafeOrderApp NV',
        initialRoute: '/',
        routes: {
          '/TablePage': (context) => TablePage(),
          '/MenuPage': (context) => MenuPage(),
          '/BeverageDetailPage': (context) => BeverageDetailPage(),
          '/OrderPage': (context) => OrderPage(),
          '/CheckOutPage': (context) => CheckOutPage(),
          TablePage.routeName: (context) => TablePage(),
          IdentifyPage.routeName: (context) => IdentifyPage(),
          ChatPage.routeName: (context) => ChatPage(),
        },
        home: IdentifyPage(),
      ),
    );
  }
}


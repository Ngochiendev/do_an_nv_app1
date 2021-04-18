import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_nv_app/modules/beverage_snapshot.dart';
import 'package:do_an_nv_app/modules/beverages.dart';
import 'package:do_an_nv_app/modules/catagories.dart';
import 'package:do_an_nv_app/modules/catagory_snapshot.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/modules/orders.dart';

class FireStoreDatabaseCatagory{
  Stream<List<CatagorySnapshot>> getCatagoryFromFireBase(){
    Stream<QuerySnapshot> streamQuerySnapshot = 
    FirebaseFirestore
        .instance.collection("catagories")
        .orderBy('catagoryId', descending: false)
        .snapshots();
    return streamQuerySnapshot.map((QuerySnapshot querySnapshot) =>
    querySnapshot.docs.map((DocumentSnapshot documentSnapshot) =>
      CatagorySnapshot.fromSnapshot(documentSnapshot)
      ).toList()
    );
  }
  Future<void> addCatagory(CatagoryDoc catagory)async{
    return await FirebaseFirestore.instance.collection("catagories")
        .add({
      'catagoryId': catagory.id,
      'catagoryName': catagory.name,
      'catagoryIcon': catagory.icon
    }).then((value) => print("Đã thêm"));
  }
}

class FireStoreDatabaseBeverage{
  Stream<List<BeverageSnapshot>> getBeverageFromFireBase(){
    Stream<QuerySnapshot> streamQuerySnapshot =
    FirebaseFirestore
        .instance.collection("beverages")
        .orderBy('catagoryId', descending: false)
        .snapshots();
    return streamQuerySnapshot.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot documentSnapshot) =>
            BeverageSnapshot.fromSnapshot(documentSnapshot)
        ).toList()
    );
  }
}

class FireStoreDatabaseTables{
  Stream<List<CartItemSnapshot>> getItemFromFirebase(String tableNum, String orderID){
    Stream<QuerySnapshot> stream =
        FirebaseFirestore
          .instance.collection('tables').doc(tableNum)
          .collection('orders').doc(orderID)
          .collection('items')
          .orderBy('id', descending: true)
          .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
      querySnapshot.docs.map((DocumentSnapshot docs) =>
        CartItemSnapshot.fromSnapshot(docs)
      ).toList()
    );
  }

  Future<OrderSnapshot> getOrderDataFromFireBase(String orderID, String tableNum){
      return FirebaseFirestore.instance
          .collection('tables').doc(tableNum)
          .collection('orders').doc(orderID)
          .get()
          .then((DocumentSnapshot snapshot) => OrderSnapshot.fromSnapshot(snapshot));
  }
  Stream<List<OrderSnapshot>> getAllOrderFromFireBase(String tableNum){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('tables').doc(tableNum)
        .collection('orders').orderBy('date',descending: true)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot doc) =>
          OrderSnapshot.fromSnapshot(doc)
        ).toList()
    );

    // return querySnapshot.docs.map((DocumentSnapshot doc) => OrderSnapshot.fromSnapshot(doc)).last
  }
  Future<void> addOrderToFirebase(String tableId, DateTime date) async{
    final String orderID = tableId+date.toString();
    final tables = FirebaseFirestore.instance.collection('tables').doc(tableId);
    return await tables.collection('orders').doc(orderID)
        .set({
      'total': 0,
      'checkout': false,
      'date': date,
      'received': false,
      'requestCheckOut': false,
      'timeRCO': '', //Request Checkout
      'waiterRCO': '',
      'waiterID': '',
      'cancelable': true
    })
        .then((value) => print("Đã thêm"));
  }
}

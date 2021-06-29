import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_nv_app/modules/beverages.dart';
import 'package:do_an_nv_app/modules/catagories.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
import 'package:do_an_nv_app/modules/employes.dart';
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

class FireStoreDatabaseOrders{

  Future<OrderSnapshot> getOrderDataFromFireBase(String orderID){
      return FirebaseFirestore.instance
          .collection('orders').doc(orderID)
          .get()
          .then((DocumentSnapshot snapshot) => OrderSnapshot.fromSnapshot(snapshot));
  }

  Stream<List<WaitersOrderSnapshot>> getWaitersFromFirebase(String orderID){
    Stream<QuerySnapshot> stream =
    FirebaseFirestore
        .instance.collection('orders').doc(orderID)
        .collection('waitersOrder')
        .orderBy('time', descending: true)
        .snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            WaitersOrderSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }

  Stream<List<CartItemSnapshot>> getItemOrderFromFirebase(String orderID){
    Stream<QuerySnapshot> stream =
    FirebaseFirestore
        .instance.collection('orders').doc(orderID)
        .collection('items')
        .where('check', isEqualTo: false)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            CartItemSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }

  Stream<List<CartItemSnapshot>> getItemCheckOutFromFirebase(String orderID){
    Stream<QuerySnapshot> stream =
    FirebaseFirestore
        .instance.collection('orders').doc(orderID)
        .collection('items')
        .where('check', isEqualTo: true)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            CartItemSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }

  Stream<List<OrderSnapshot>> getAllOrderFromFireBase(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('orders').where('checkout', isEqualTo: false)
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
    final orders = FirebaseFirestore.instance.collection('orders');
    return await orders.doc(orderID)
        .set({
      'orderID': tableId+date.toString(),
      'total': 0,
      'checkout': false,
      'date': date,
      'table': tableId,
      'received': false,
      'requestCheckOut': false,
      'timeRCO': null, //Request Checkout
      'waiterRCO': '',
      'waiterRCOID': '',
      'cancelable': true
    });
  }
}

class FireStoreDatabaseEmployers{
  Stream<List<EmployeSnapshot>> getEmployeeDataFromFireBase(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('employes').snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
      querySnapshot.docs.map((DocumentSnapshot docs) =>
        EmployeSnapshot.fromSnapshot(docs)
      ).toList()
    );
  }
}

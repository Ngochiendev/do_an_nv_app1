import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:do_an_nv_app/modules/cart_item.dart';
class TableOrder{
  Cart order;
  TableOrder({@required this.order});

}
class Tables with ChangeNotifier{
  Map<String, TableOrder> _orderTableList = {};
  Map<String, TableOrder> get orderTableList{
    return {..._orderTableList};
  }

  Future<void> addOrderInTable(String tableId, Cart cart) async{
    if(!_orderTableList.containsKey(tableId)){
      _orderTableList.putIfAbsent(tableId, () =>
          TableOrder(
              order: cart
          )
      );
    }
    else {
      _orderTableList.update(tableId, (exisOrder) =>
        TableOrder(order: exisOrder.order)
      );
    }
    notifyListeners();
  }


  void addItemInOrder(String orderID,String pdId, String name, int price, String desc, String image ){
    _orderTableList[orderID].order.addToCart(pdId, name, price, desc,image);
    notifyListeners();
  }

  void removeItemInOrder(String orderID, String pdId){
    _orderTableList[orderID].order.removeItem(pdId);
    notifyListeners();
  }
  void removeSingleItemInOrder(String orderID, String pdId){
    _orderTableList[orderID].order.removeSingle(pdId);
    notifyListeners();
  }
  void addQuantityItemInOrder(String orderID, String pdId){
    _orderTableList[orderID].order.addQuantity(pdId);
    notifyListeners();
  }
  int coutItemInOrder(String orderID){
    if(_orderTableList.containsKey(orderID)){
      return _orderTableList[orderID].order.countItemInCart;
    }else{
      return 0;
    }

  }
  void removeOrder(String orderID){
    _orderTableList.remove(orderID);
    notifyListeners();
  }
  Future<void> addNotification(String waiterName, String tableNum,
       DateTime date, String type, String waiterID, String orderID) async{
    await FirebaseFirestore.instance.collection('notifications').add({
      'type': type,
      'tableNum': tableNum,
      'date': date,
      'waiterName': waiterName,
      'waiterID': waiterID,
      'orderID': orderID
    });
  }
  Future<void> sendOrder(String orderID, List<CartItem> carts,
      String tableNum,String waiterName, String waiterID, String timeReq) async{

    final order =  FirebaseFirestore.instance.collection('tables').doc(tableNum).collection('orders').doc(orderID);
    order.update({
      'received': false,
      'cancelable': false,
    });
    WriteBatch batch = FirebaseFirestore.instance.batch();

    await batch.set(order.collection('carts').doc(waiterName.trim()+timeReq), {
      'waiterName': waiterName,
      'waiterID': waiterID,
      'time': timeReq,
      'check': false
    });
    carts.forEach((item) async{
      await batch.set(order.collection('carts').doc(waiterName.trim()+timeReq).collection('cartItem').doc(), {
        'id': item.id,
        'name': item.name,
        'quantity': item.quantity,
        'desc': item.description,
        'price': item.price,
        'image': item.image
      });
    });
    batch.commit();
  }
  void cancelOrder(String tableNum, String orderID) async{
    final order = FirebaseFirestore.instance.collection('tables').doc(tableNum)
        .collection('orders').doc(orderID);
    await order.delete();
    //Xoa cart
    // await order.collection('carts').snapshots()
    //     .forEach((QuerySnapshot querySnapshot) {
    //       querySnapshot.docs.forEach((element) {
    //         element.reference.delete();
    //       });
    // });
    // Xoa order
  }
  Future<void> comfirmCheckOut(String orderID, String tableNum, String waiter, String waiterID) async{
    return await FirebaseFirestore.instance.collection('tables').doc(tableNum).collection('orders').doc(orderID)
        .update({
      'requestCheckOut': true,
      'waiterRCO': waiter,
      'timeRCO': DateTime.now().toString(),
      'waiterID': waiterID
    }).then((value) => print('checkout'));
  }
  // Future<int> getOrderTotal(String orderID,String t){}

}

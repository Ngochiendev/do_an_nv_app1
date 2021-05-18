import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_nv_app/modules/beverages.dart';
import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final int quantity;
  final String name;
  final double price;
  final String note;
  final String image;

  const CartItem({
    @required this.id,
    @required this.price,
    @required this.name,
    @required this.image,
    this.note,
    this.quantity,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) =>
      CartItem(
          id: json['id'],
          price: double.parse(json['price'].toString()),
          name: json['name'],
          note: json['note'],
          quantity: json['quantity'],
          image: json['image']
      );
}
class CartItemSnapshot{
  CartItem cartItem;
  DocumentReference doc;
  CartItemSnapshot({this.cartItem, this.doc});

  CartItemSnapshot.fromSnapshot(DocumentSnapshot snapshot):
      cartItem = CartItem.fromJson(snapshot.data()),
      doc = snapshot.reference;
}
class Cart with ChangeNotifier{
    int _countItem = 0;
    Map<String, CartItem> _items= {};
    Map<String, CartItem> get items{
      return {..._items};
    }
    int get itemCount{
      return _items.length;
    }
    int get countItemInCart{
      return _countItem;
    }
    void addToCart(Beverages beverage){
      if(_items.containsKey(beverage.id)) {
        _items.update(beverage.id, (exisItem) =>
            CartItem(id: DateTime.now().toString(),
                price: exisItem.price,
                name: exisItem.name,
                quantity: exisItem.quantity +1,
                note: exisItem.note,
                image: exisItem.image
            ));
        _countItem++;
      }else {
        _items.putIfAbsent(beverage.id, () =>
            CartItem(id: DateTime.now().toString(),
                price: beverage.price,
                name: beverage.name,
                quantity: 1,
                note: 'Không có ghi chú',
                image: beverage.image
            ));
        _countItem++;
      }
      notifyListeners();
    }
    void addToCartWithNote(Beverages beverage, String note){

      _items.putIfAbsent(beverage.id+'note${_countItem}', () =>
          CartItem(id: DateTime.now().toString(),
              price: beverage.price,
              name: beverage.name,
              quantity: 1,
              note: note,
              image: beverage.image
          ));
      _countItem++;
      notifyListeners();
    }
    void addQuantity(String pdId){
      _items.update(pdId, (exisItem) =>
          CartItem(id: DateTime.now().toString(),
              price: exisItem.price,
              name: exisItem.name,
              quantity: exisItem.quantity +1,
              note: exisItem.note,
              image: exisItem.image
          ));
      _countItem++;
      notifyListeners();
    }
    void removeItem(String pdId){
      _countItem -= _items[pdId].quantity;
      _items.remove(pdId);
      notifyListeners();
    }
    void removeSingle(String pdId){
      _items.update(pdId, (exisItem) =>
          CartItem(id: DateTime.now().toString(),
              price: exisItem.price,
              name: exisItem.name,
              quantity: exisItem.quantity > 1 ? exisItem.quantity - 1 : exisItem.quantity,
              note: exisItem.note,
              image: exisItem.image
          ));
      _countItem--;
      notifyListeners();
    }
    double totalMoney(){
      double sum=0;
      _items.forEach((pdId, item) {
        sum+=(item.price*item.quantity);
      });
      return sum;
    }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final int quantity;
  final String name;
  final int price;
  final String description;
  final String image;

  const CartItem({
    @required this.id,
    @required this.price,
    @required this.name,
    @required this.image,
    this.description,
    this.quantity,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) =>
      CartItem(
          id: json['id'],
          price: json['price'],
          name: json['name'],
          description: json['desc'],
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
    void addToCart(String pdId, String name, int price, String desc, String image){
      int newProductNum = 0;
      if(_items.containsKey(pdId)) {
        _items.putIfAbsent(pdId+'${newProductNum + 1}', () =>
            CartItem(id: DateTime.now().toString(),
                price: price,
                name: name,
                quantity: 1,
                description: desc,
                image: image
            ));
        _countItem++;
      }else {
        _items.putIfAbsent(pdId, () =>
            CartItem(id: DateTime.now().toString(),
                price: price,
                name: name,
                quantity: 1,
                description: desc,
                image: image
            ));
        _countItem++;
      }
      notifyListeners();
    }
    void addQuantity(String pdId){
      _items.update(pdId, (exisItem) =>
          CartItem(id: DateTime.now().toString(),
              price: exisItem.price,
              name: exisItem.name,
              quantity: exisItem.quantity +1,
              description: exisItem.description,
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
              description: exisItem.description,
              image: exisItem.image
          ));
      _countItem--;
      notifyListeners();
    }
    int totalMoney(){
      int sum=0;
      _items.forEach((pdId, item) {
        sum+=(item.price*item.quantity);
      });
      return sum;
    }
}
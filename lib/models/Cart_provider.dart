import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tiki_project/models/product.dart';
import 'dart:convert';


class CartItem {
   final int id;
   final String name;
   final String thumbnailUrl;
   final int price;
   final int originalPrice;
   late  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.price,
    required this.originalPrice,
    required final this.quantity,
  });
}


class CartProvider extends ChangeNotifier {

  List<CartItem> _cartList = [];

  myCartCount(){
    int count = 0;
    for (var item in _cartList) {
      count += item.quantity;
    }
    return count;
  }

  List<CartItem> get cartList => _cartList;

  clearCart() {
    _cartList.clear();
    notifyListeners();
  }

  removeItem(int id,) {
    _cartList.remove(_cartList.firstWhere((p) => p.id == id));
    notifyListeners();
  }

  addItemToCart(int id, String name, String thumbnailUrl, int price, int originalPrice,) {
    if(_cartList.where((p) => p.id == id).isNotEmpty){
      _cartList.firstWhere((p) => p.id == id).quantity+=1;
    }else{
      _cartList.add(CartItem(id: id, name: name, thumbnailUrl: thumbnailUrl, price: price, originalPrice: originalPrice, quantity: 1));
      print('add $name');
    }
    notifyListeners();
  }
  getCartTotal(){
    double price = 0;
    for (var item in _cartList) {
      price += item.quantity*item.price;
    }
    return price;
  }
  void sub(CartItem item){
      item.quantity--;
      if(item.quantity<0) {
        item.quantity =0;
      }
      notifyListeners();
  }

  void add(CartItem item){
    item.quantity++;
    notifyListeners();
  }
}








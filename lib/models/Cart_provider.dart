import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final int id;
  final String name;
  final String thumbnailUrl;
  final int price;
  final int originalPrice;
  late int quantity;
  late bool ischecked;

  CartItem({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.price,
    required this.originalPrice,
    required final this.quantity,
    required this.ischecked,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantity": quantity,
    };
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartList = [];
  late bool _allischecked = true;

  List<CartItem> get cartList => _cartList;

  bool get allischecked => _allischecked;

  set allischecked(bool value) {
    _allischecked = value;
    notifyListeners();
  }

  checkitem(CartItem item, value) {
    item.ischecked = value;
    notifyListeners();
  }

  myCartCount() {
    int count = 0;
    for (var item in _cartList.where((p) => p.ischecked == true).toList()) {
      count += item.quantity;
      print(item.name);
    }
    return count;
  }

  clearCart() {
    _cartList.clear();
    notifyListeners();
  }

  removeItem(
    int id,
  ) {
    _cartList.remove(_cartList.firstWhere((p) => p.id == id));
    notifyListeners();
  }

  addItemToCart(
    int id,
    String name,
    String thumbnailUrl,
    int price,
    int originalPrice,
  ) {
    if (_cartList.where((p) => p.id == id).isNotEmpty) {
      _cartList.firstWhere((p) => p.id == id).quantity += 1;
    } else {
      _cartList.add(CartItem(
          id: id,
          name: name,
          thumbnailUrl: thumbnailUrl,
          price: price,
          originalPrice: originalPrice,
          quantity: 1,
          ischecked: true));
      print('add $name');
    }
    notifyListeners();
  }

  getCartTotal() {
    double price = 0;
    for (var item in cartList.where((p) => p.ischecked == true).toList()) {
      price += item.quantity * item.price;
    }
    return price;
  }

  void sub(CartItem item) {
    item.quantity--;
    if (item.quantity < 1) {
      item.quantity = 1;
    }
    notifyListeners();
  }

  void add(CartItem item) {
    item.quantity++;
    notifyListeners();
  }
}

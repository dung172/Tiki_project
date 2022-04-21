import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier{

  int _counter = 0;
  int get counter =>_counter;

  double _totalprice = 0;
  double get totalprice => _totalprice;


}
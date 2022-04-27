import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiki_project/models/Cart_provider.dart';
import '../models/api.dart';
import 'Products.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
final oCcy = NumberFormat("#,##0", "en_US");


class MyCart extends StatelessWidget {
  static const nameRoute = '/Cart';
  const MyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cart',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, MyProducts.nameRoute),
            ),
            title: const Text('Giỏ hàng'),
          ),
          body: const CartDetails(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Consumer<CartProvider>(
                builder: (BuildContext context, _cart, Widget? child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng cộng',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${oCcy.format(_cart.getCartTotal()).toString()}đ',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                        ApiCall().postCart(_cart.cartList).then((response){
                          if (response.statusCode == 201) {
                            final snackBar = SnackBar(
                              content: Text('đặt hàng thành công!!!!!'),
                              duration: Duration(seconds: 2),//default is 4s
                            );
                            // Find the Scaffold in the widget tree and use it to show a SnackBar.
                            Scaffold.of(context).showSnackBar(snackBar);
                          } else {
                            throw Exception(
                                'ERROR. Can not get product list ${response.statusCode} ');
                          }
                        });
                    },
                    child: Text(
                      'Chọn mua(${_cart.myCartCount().toString()})',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red, fixedSize: Size(180, 50)),
                  ),
                ],
              ),

              ),
            ),
          ),
        ));
  }
}

class CartDetails extends StatefulWidget {
  const CartDetails({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CartDetails();
  }
}

class _CartDetails extends State<CartDetails> {
  bool _ischecked = false;
  late FirebaseMessaging messaging;

  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            onChanged: (bool? value) {
              setState(() {
                _ischecked = value!;
              });
            },
            value: _ischecked,
          ),
          title: Text('Tất cả (${_cartProvider.cartList.length}) sản phẩm'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _cartProvider.clearCart();
            },
          ),
        ),
        const Divider(),
        Expanded(
            child: ListView.separated(
          itemCount: _cartProvider.cartList.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) => Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? value) {
                    setState(() {
                      value = value!;
                    });
                  },
                ),
                SizedBox(
                  width: 100,
                  height: 150,
                  child:
                      Image.network(_cartProvider.cartList[index].thumbnailUrl),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          _cartProvider.cartList[index].name,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              '${oCcy.format(_cartProvider.cartList[index].price).toString()}đ',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                '${oCcy.format(_cartProvider.cartList[index].originalPrice)
                                    .toString()}đ',style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: Colors.black12)),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    iconSize: 14,
                                    onPressed: () => _cartProvider.sub(_cartProvider.cartList[index]),
                                  ),
                                  Text(_cartProvider.cartList[index].quantity
                                      .toString()),
                                  IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 14,
                                      onPressed: () =>_cartProvider.add(_cartProvider.cartList[index]))
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                print(_cartProvider.cartList[index].id);
                                _cartProvider.removeItem(_cartProvider.cartList[index].id);
                              },
                              child: Text('xóa'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

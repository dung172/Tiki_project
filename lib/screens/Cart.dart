import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tiki_project/models/Cart_provider.dart';
import '../models/api.dart';
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
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Giỏ hàng'),
          ),
          body: const CartDetails(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
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
                        const Text(
                          'Tổng cộng',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${oCcy.format(_cart.getCartTotal()).toString()}đ',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ApiCall()
                            .postCart(_cart.cartList
                                .where((p) => p.ischecked == true)
                                .toList())
                            .then((response) {
                          if (response.statusCode == 201) {
                            const snackBar = SnackBar(
                              content: Text('đặt hàng thành công!!!!!'),
                              duration: Duration(seconds: 2), //default is 4s
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
                        style: const TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red, fixedSize: const Size(180, 50)),
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
  late FirebaseMessaging messaging;

  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            onChanged: (bool? value) {
                _cartProvider.allischecked = value!;
              for (var item in _cartProvider.cartList) {
                item.ischecked = _cartProvider.allischecked;
              }
            },
            value: _cartProvider.allischecked,
          ),
          title: Text('Tất cả (${_cartProvider.cartList.where((element) => element.ischecked == true).length}) sản phẩm'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (_cartProvider.cartList.isNotEmpty) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: const Text('bạn có chắc muốn xóa toàn bộ giỏ hàng?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _cartProvider.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        const Divider(),
        Expanded(
            child: ListView.separated(
          itemCount: _cartProvider.cartList.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Checkbox(
                value: _cartProvider.cartList[index].ischecked,
                onChanged: (bool? value) {
                  _cartProvider.checkitem(
                      _cartProvider.cartList[index], value!);
                  if (_cartProvider.cartList[index].ischecked == false) {
                    _cartProvider.allischecked = false;
                  }
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
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            '${oCcy.format(_cartProvider.cartList[index].price).toString()}đ',
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              '${oCcy.format(_cartProvider.cartList[index].originalPrice).toString()}đ',
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey),
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
                                  icon: const Icon(Icons.remove),
                                  iconSize: 14,
                                  onPressed: () => _cartProvider
                                      .sub(_cartProvider.cartList[index]),
                                ),
                                Text(_cartProvider.cartList[index].quantity
                                    .toString()),
                                IconButton(
                                    icon: const Icon(Icons.add),
                                    iconSize: 14,
                                    onPressed: () => _cartProvider
                                        .add(_cartProvider.cartList[index]))
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              print(_cartProvider.cartList[index].id);
                              _cartProvider
                                  .removeItem(_cartProvider.cartList[index].id);
                            },
                            child: const Text('xóa'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

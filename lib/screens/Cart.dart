import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiki_project/models/product.dart';
import 'package:quantity_input/quantity_input.dart';
import 'Products.dart';

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
              onPressed: () => Navigator.pop(context, MyProducts.nameRoute),
            ),
            title: const Text('Giỏ hàng'),
          ),
          body: const Cart(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12)) ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround ,
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    children: [
                      Text('Tổng cộng',style: TextStyle( fontSize: 18),),
                      Text('2600000đ', style: TextStyle(color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Chọn mua(2)',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.red,fixedSize: Size(180, 50)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  late bool _isChecked = true;
  late int _itemCount = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            onChanged: (bool) {},
            value: _isChecked,
          ),
          title: Text('Tất cả () sản phẩm'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ),
        const Divider(),
        Expanded(
            child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) => ListTile(
            leading: Checkbox(
              onChanged: (bool) { },
              value: _isChecked,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Image.network(
                      'https://salt.tikicdn.com/cache/280x280/ts/product/19/5e/21/e9545516e51437aa3266c8a684c83f1d.jpg'),
                ),
                Column(
                  children: [
                    Text('Renf luye tu duy phan vien'),
                    Text('240000đ',style: TextStyle(color: Colors.red),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1,color: Colors.black12)),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                iconSize: 14,
                                onPressed: () => setState(() {
                                  _itemCount--;
                                  if (_itemCount < 0) _itemCount = 0;
                                }),
                              ),
                              Text(_itemCount.toString()),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  iconSize: 14,
                                  onPressed: () => setState(() => _itemCount++))
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('xóa'),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiki_project/models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../models/Cart_provider.dart';
import 'Cart.dart';

final oCcy = NumberFormat("#,##0", "en_US");

class MyDetails extends StatefulWidget {
  const MyDetails({Key? key}) : super(key: key);
  static const nameRoute = '/details';

  @override
  State<StatefulWidget> createState() {
    return _MyDetails();
  }
}

class _MyDetails extends State<MyDetails> {
  @override
  Widget build(BuildContext context) {
    final Product products =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, MyCart.nameRoute);
              },
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(products.thumbnailUrl),
            Column(
              children: [
                Text(
                  products.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: products.ratingAverage,
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    Text(
                      '(${products.reviewCount})  ${products.quantitySold?.value == null ? '' : '| ${products.quantitySold!.text}'}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add_link)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${oCcy.format(products.price)}đ ',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '${oCcy.format(products.originalPrice)}đ',
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 18,
                          decoration: TextDecoration.lineThrough),
                    ),
                    const Spacer(),
                    discount_rate(products),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addItemToCart(products.id, products.name, products.thumbnailUrl, products.price, products.originalPrice);
                  Navigator.popAndPushNamed(context, MyCart.nameRoute);
                },
                child: const Text(
                  'Chọn mua',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget discount_rate(Product products) {
    if (products.discountRate > 0) {
      return Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.pink[100],
        ),
        child: Center(
          child: Text(
            '-${products.discountRate}%',
            style: const TextStyle(color: Colors.red,fontSize: 18),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

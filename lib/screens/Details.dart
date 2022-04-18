import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiki_project/models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0", "en_US");

class MyDetails extends StatefulWidget {
  const MyDetails({Key? key}) : super(key: key);
  static final nameRoute = '/details';

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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(products.thumbnailUrl),
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
                IconButton(onPressed: () {}, icon: Icon(Icons.add_link)),
                IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                  '${products.originalPrice.toString()}đ ',
                  style: TextStyle(
                      color: Colors.black45,
                      decoration: TextDecoration.lineThrough),
                ),
                discount_rate(products),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
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
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.pink[100],
        ),
        child: Center(
          child: Text(
            products.discountRate <= 0 ? '' : '-${products.discountRate}%',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else
      return Container();
  }
}

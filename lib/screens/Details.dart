import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiki_project/models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyDetails extends StatefulWidget{
  const MyDetails({Key? key}) : super(key: key);
  static final nameRoute = '/details';
  @override
  State<StatefulWidget> createState() {
    return _MyDetails();
  }
}
class _MyDetails extends State<MyDetails>{
  @override
  Widget build(BuildContext context) {
    final Product products = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context),),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5 , 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(products.thumbnailUrl),
            Text(products.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800,fontFamily: 'Times New Roman'),),
            Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RatingBar.builder(
                  itemSize: 20,
                  initialRating: products.ratingAverage,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                  },
                ),
                Text('(${products.reviewCount})  ${products.quantitySold?.value == null ? '': '| ${products.quantitySold!.text}' }',overflow: TextOverflow.ellipsis,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${products.price}đ',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.redAccent[100],
                  ),
                  child: Text(products.discountRate<=0 ? '': '-${products.discountRate}%',  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Chọn mua'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
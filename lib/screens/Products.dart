import 'package:flutter/material.dart';
import 'package:tiki_project/models/product.dart';
import 'package:tiki_project/models/api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Details.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0", "en_US");

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);
  static const nameRoute = '/products';

  @override
  State<StatefulWidget> createState() {
    return _MyProducts();
  }
}

class _MyProducts extends State<MyProducts> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  //tạo state query
  String query = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {},
          ),
          title: Center(
            child: Container(
              width: 700,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: Colors.white,
              child: _buildSearch(),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
          ],
        ),
        body: FutureBuilder<List<Product>>(
          future: getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!!!'),
              );
            } else if (snapshot.hasData) {
              return ProductsList(
                  //filtered list product
                  products: snapshot.data!
                      .where((p) => p.name.contains(query))
                      .toList());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  //search text field
  Widget _buildSearch() => TextField(
        controller: _searchController,
        onChanged: (query) {
          //thay this.query bằng query
          setState(() {
            _isSearching = true;
            this.query = query;
            // query = query;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search....',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isSearching == true
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      this.query = '';
                      _isSearching = false;
                    });
                  },
                )
              : null,
        ),
      );
}

//list product
class ProductsList extends StatelessWidget {
  const ProductsList({Key? key, required this.products}) : super(key: key);
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1 / 1.3,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white54,
          ),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, MyDetails.nameRoute,
                arguments: products[index]),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: Image.network(products[index].thumbnailUrl),
                    ),
                    Text(
                      products[index].name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          itemSize: 12,
                          initialRating: products[index].ratingAverage,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        Text(
                          '(${products[index].reviewCount}) ',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                            products[index].quantitySold?.value != null
                                ? '| ${products[index].quantitySold!.text}'
                                : '',
                            style: TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis)
                      ],
                    ),
                    discount_rate(products[index]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget discount_rate(Product products) {
    if (products.discountRate > 0) {
      return Row(
        children: [
          Text(
            '${oCcy.format(products.price)}đ  ',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          Container(
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
          ),
        ],
      );
    } else
      return Text(
        '${oCcy.format(products.price)}đ  ',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
  }
}

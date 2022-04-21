import 'package:flutter/material.dart';
import 'package:tiki_project/models/product.dart';
import 'package:tiki_project/models/api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Cart.dart';
import 'Details.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat("#,##0", "en_US");

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
  bool _isLoading = false;
  late int _itemsperpage =40;
  late int _page =1;
  bool _hasmore =true;
  final TextEditingController _searchController = TextEditingController();
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasmore = true;
    _loadmore();
  }

  void _loadmore({String name=''}){
    print(_page);
    print(_itemsperpage);
    _isLoading = true;
    ApiCall().getProductsperpage(_page, _itemsperpage, name: name).then((List<Product> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasmore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          products.addAll(fetchedList);
        });
      }
    });
    _itemsperpage=20;
    _page++;
  }

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
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyCart.nameRoute);
                },
                icon: const Icon(Icons.shopping_cart))
          ],
        ),
        body: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1 / 1.3,
      ),
      itemCount:  _hasmore?products.length +1:products.length,
      itemBuilder: (context, index) {
        if (index >= products.length) {
          if (!_isLoading) {
            _loadmore();
          }
          return const Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 24,
              width: 24,
            ),
          );
        }
        return ProductsList(products: products[index]);
      },
    ),

    );
  }

  //search text field
  Widget _buildSearch() => TextField(
    controller: _searchController,
    onChanged: (query) {
      //thay this.query bằng query
      setState(() {
        _isSearching = true;
        _loadmore(name:query);
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
  final Product products;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white54,
      ),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, MyDetails.nameRoute,
            arguments: products),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.network(products.thumbnailUrl),
                ),
                Text(
                  products.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemSize: 12,
                      initialRating: products.ratingAverage,
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
                      '(${products.reviewCount}) ',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                        products.quantitySold?.value != null
                            ? '| ${products.quantitySold!.text}'
                            : '',
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
                discountRate(products),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget discountRate(Product products) {
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
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        '${oCcy.format(products.price)}đ  ',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    }
  }
}

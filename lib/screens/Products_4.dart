import 'package:flutter/material.dart';
import 'package:tiki_project/models/product.dart';
import 'package:tiki_project/models/api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Cart.dart';
import 'Details.dart';
import 'package:intl/intl.dart';
import 'dart:async';

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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  bool _isLoading = false;
  late int _itemsPerPage = 40;
  late int _page = 1;
  late List<Product> productList = [];
  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoading = true;
          _itemsPerPage = 20;
          _page++;
        });
        _loadMore(name: _searchController.text);
      }
    });
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          initState();
        });
      }
    });
  }

  void _loadMore({String name = ''}) {
    //print('_loadmore called with param [$name]');
    // _isLoading = true;
    ApiCall()
        .getProductsperpage(_page, _itemsPerPage, name: name)
        .then((List<Product> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          //print('====== _loadmore done, and printing 0 products, name: $name, page: $_page');
        });
      } else {
        setState(() {
          _isLoading = false;
          productList.addAll(fetchedList);
          //print('====== _loadmore done, and printing ${fetchedList.length} products');
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //print('Renderingggggggggggggggggggg');

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
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    _isSearching = true;
                    productList.clear();
                    _page = 1;
                    _loadMore(name: query);
                  });
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
                            _searchController.text = '';
                            _isSearching = false;
                            productList.clear();
                            _page = 1;
                            _loadMore();
                          });
                        },
                      )
                    : null,
              ),
            ),
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
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 1 / 1.3,
        ),
        itemCount: _isLoading ? productList.length + 1 : productList.length,
        itemBuilder: (context, index) {
          if (index >= productList.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ProductItem(product: productList[index]);
          }
        },
      ),
    );
  }
}

//list product
class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white54,
      ),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, MyDetails.nameRoute,
            arguments: product),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.network(product.thumbnailUrl),
                ),
                Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemSize: 12,
                      initialRating: product.ratingAverage,
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
                      '(${product.reviewCount}) ',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                        product.quantitySold?.value != null
                            ? '| ${product.quantitySold!.text}'
                            : '',
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
                product.discountRate == 0
                    ? Text(
                        '${oCcy.format(product.price)}đ  ',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    : Row(
                        children: [
                          Text(
                            '${oCcy.format(product.price)}đ  ',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: Colors.pink[100],
                            ),
                            child: Center(
                              child: Text(
                                product.discountRate <= 0
                                    ? ''
                                    : '-${product.discountRate}%',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//using call Server
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiki_project/models/product.dart';
import 'package:tiki_project/models/api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Details.dart';

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
  late Future<List<Product>> _getProduct ;

  @override
  void initState() {
    _getProduct = getAllProducts();
    super.initState();
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
          ],
        ),
        body: FutureBuilder<List<Product>>(
          future: _getProduct,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!!!'),
              );
            } else if (snapshot.hasData) {
              return ProductsList(products: snapshot.data!);
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
          setState(() {
            _isSearching = true;
            _getProduct = getProductsbyName(query);
          });
        },
        decoration: InputDecoration(
          hintText: 'Search...',
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
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1 / 1.5,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Consumer<Decorr>(
          builder: (context,Decorr, child){
            return Container(
                height: 500,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white54,
                    border: Decorr.borderr,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MyDetails.nameRoute, arguments: products[index]);
                    Decorr.changeborderr();
                  } ,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                itemSize: 13,
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
                              Text('(${products[index].reviewCount}) '),
                              Text(
                                  products[index].quantitySold?.value == null ? '' : '| ${products[index].quantitySold!.text}',
                                  overflow: TextOverflow.ellipsis)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${products[index].price}đ',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                products[index].discountRate <= 0 ? '' : '-${products[index].discountRate}%',
                                style: TextStyle(
                                  backgroundColor: Colors.redAccent[100],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          },
        );
      },
    );
  }
}
class Decorr extends ChangeNotifier{
  dynamic borderr;
  void changeborderr(){
    borderr =  Border.all(color: Colors.blue);
    notifyListeners();
  }
}

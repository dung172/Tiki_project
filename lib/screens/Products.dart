import 'package:flutter/material.dart';
import 'package:tiki_project/models/product.dart';
import 'package:tiki_project/models/api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class MyProducts extends StatefulWidget{
  const MyProducts({Key? key}) : super(key: key);
  static final nameRoute = '/products';
  @override
  State<StatefulWidget> createState() {
    return _MyProducts();
  }
}
class _MyProducts extends State<MyProducts>{
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_rounded), onPressed: (){},),
          title: Center(
            child: Container(
              width: 700,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                onChanged: (query){ setState(() {
                  _isSearching = true;
                }); } ,
                decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _isSearching?IconButton(icon:Icon(Icons.clear),onPressed: (){
                      setState(() {
                      _searchController.clear();
                      _isSearching = false;
                    });  },):null,
                ),
              ),
            ),
          ),
          actions: [IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart))],
          ),
        body: FutureBuilder<List<Product>>(
          future: getAllProducts(),
          builder: (context,snapshot){
            if(snapshot.hasError)
              return const Center(
                child: Text('An error has occurred!!!'),
              );
            else if(snapshot.hasData)
              return ProductsList(products: snapshot.data!);
            else
              return const Center(child: CircularProgressIndicator(),);
          },
        )

        // Container(
        //   margin: EdgeInsets.fromLTRB(5,10,5,0),
        //   child: ProductsList() ,
        // )
    );
  }
}

class ProductsList extends StatelessWidget{
  const ProductsList ({Key?key, required this.products}): super(key: key);
  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1/1.5,
      ),
      itemCount: products.length,
      itemBuilder: (context,index){
        return Container(
          height: 700,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white54,
          ),
          child: Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5 , 10),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Image.network(products[index].thumbnailUrl),
                  ),
                  Text(products[index].name),
                  Row(
                    children: [
                    RatingBar.builder(
                      itemSize: 15,
                    initialRating: products[index].ratingAverage,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                    },
                  ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiki_project/models/product.dart';

Future<List<Product>> getAllProducts() async {
  var response = await http.get(Uri.parse('http://172.29.4.126:30000/products/'));
  // await Future.delayed(const Duration(milliseconds: 500));

  if (response.statusCode == 200) {
    final List<Product>  productList = await json
        .decode(response.body)
        .map<Product>((item) => Product.fromJson(item))
        .toList();
    // print('productList: $productList');
    return productList;
  } else {
    throw Exception(
        'ERROR. Can not get product list ${response.statusCode} ${response.body}');
  }
}

Future<Product> getProductById(int productId) async {
  var response =
      await http.get(Uri.parse('http://172.29.4.126:30000/products/$productId'));
  // await Future.delayed(const Duration(milliseconds: 500));

  if (response.statusCode == 200) {
    return Product.fromJson(json.decode(response.body));
  } else {
    throw Exception(
        'ERROR. Can not get product ${response.statusCode} ${response.body}');
  }
}

Future<List<Product>> getProductsbyName(String name) async {
  var response = await http.get(Uri.parse('http://172.29.4.126:30000/products?name_like=$name'));
  // await Future.delayed(const Duration(milliseconds: 500));

  if (response.statusCode == 200) {
    final List<Product>  productList = await json
        .decode(response.body)
        .map<Product>((item) => Product.fromJson(item))
        .toList();
    return productList;
  } else {
    throw Exception(
        'ERROR. Can not get product list ${response.statusCode} ${response.body}');
  }
}



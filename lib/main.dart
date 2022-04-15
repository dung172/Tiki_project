import 'package:flutter/material.dart';
import 'package:tiki_project/screens/Products.dart';
//import 'package:tiki_project/screens/Products_2.dart';
import 'package:tiki_project/screens/Details.dart';
void main(){
  runApp(const MyTiki());
}
class MyTiki extends StatelessWidget{
  const MyTiki({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiki',
      initialRoute: '/products',
      routes: {
        MyProducts.nameRoute: (_)=> MyProducts(),
        MyDetails.nameRoute: (_)=> MyDetails(),
      },
    );
  }
}
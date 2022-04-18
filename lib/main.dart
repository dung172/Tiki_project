import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiki_project/screens/Products.dart';
//import 'package:tiki_project/screens/Products_2.dart';
import 'package:tiki_project/screens/Details.dart';
import 'screens/Cart.dart';

void main() {
  runApp(const MyTiki());
}

class MyTiki extends StatelessWidget {
  const MyTiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiki',
      initialRoute: MyProducts.nameRoute,
      routes: {
        MyProducts.nameRoute: (_) => MyProducts(),
        MyDetails.nameRoute: (_) => MyDetails(),
        MyCart.nameRoute: (_) => MyCart(),
      },
    );
  }
}
//
// class MyTiki2 extends StatelessWidget {
//   const MyTiki2({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<Decorr>(
//       create: (context) => Decorr(),
//       child: MaterialApp(
//         title: 'Tiki',
//         initialRoute: MyProducts.nameRoute,
//         routes: {
//           MyProducts.nameRoute: (_) => MyProducts(),
//           MyDetails.nameRoute: (_) => MyDetails(),
//           MyCart.nameRoute: (_) => MyCart(),
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tiki_project/models/Cart_provider.dart';
import 'package:tiki_project/screens/Products_4.dart';
import 'package:tiki_project/screens/Details.dart';
import 'screens/Cart.dart';
import 'firebase_chatroom.dart';
import 'firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyTiki());
}
// void main() {
//   runApp(const MyTiki());
// }

// class MyTiki extends StatelessWidget {
//   const MyTiki({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tiki',
//       initialRoute:  MyProducts.nameRoute,
//       routes: {
//         MyProducts.nameRoute: (_) => MyProducts(),
//         MyDetails.nameRoute: (_) => MyDetails(),
//         // '/login': (_)=>FirebaseLoginExample(),
//         MyCart.nameRoute: (_) => MyCart(),
//         // '/chat':(_)=>FirebaseChatroomExample(),
//       },
//     );
//   }
// }

class MyTiki extends StatelessWidget {
  const MyTiki({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        )

      ],
      child: MaterialApp(
        title: 'Tiki',
        initialRoute: MyProducts.nameRoute,
        routes: {
          MyProducts.nameRoute: (_) => const MyProducts(),
          MyDetails.nameRoute: (_) => const MyDetails(),
          MyCart.nameRoute: (_) => const MyCart(),
       '/login': (_)=>const FirebaseLoginExample(),
          '/chat':(_)=>const FirebaseChatroomExample(),
        },
      ),

    );
  }
}

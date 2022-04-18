// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tiki_project/models/product.dart';
// import 'package:quantity_input/quantity_input.dart';
// class MyCart extends StatelessWidget{
//   static const nameRoute = '/Cart';
//   const MyCart({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cart',
//       home: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){},),
//           title: const Text('Giỏ hàng'),
//         ),
//         body:const Cart() ,
//       ),
//     );
//   }
// }
// class Cart extends StatefulWidget{
//   const Cart({Key? key}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() {
//     return _Cart();
//   }
// }
// class _Cart extends State<Cart>{
//   final bool _isChecked = true;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           ListTile(
//             leading: Checkbox(onChanged: (bool){}, value: _isChecked,),
//             title: Text('Tất cả () sản phẩm'),
//             trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){},),
//           ),
//           const Divider(),
//           Expanded(child: ListView(
//             itemExtent: 120,
//             children: [
//               ListTile(
//
//                 leading: Checkbox(onChanged: (bool){}, value: _isChecked,),
//                 title: Row(
//                   children: [
//                     Expanded(child: Image.network('https://salt.tikicdn.com/cache/280x280/ts/product/61/5a/31/a3e33f721b70e4f3a9ea9be19fd85241.jpg')),
//                     Column(
//                       children: [
//                         Text('tu duy phan bien sieu toc'),
//                         Text('2000000'),
//                         Row(
//                           children: [
//                             QuantityInput(value: 1, onChanged: (s){})
//                           ],
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(),
//             ],
//           )),
//         ],
//       )
//     );
//   }
// }

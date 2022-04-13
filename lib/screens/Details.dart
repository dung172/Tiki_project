import 'package:flutter/material.dart';

class MyDetails extends StatelessWidget{
  const MyDetails({Key? key}) : super(key: key);
  static final nameRoute = '/details';
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Container(),
    );
  }
}
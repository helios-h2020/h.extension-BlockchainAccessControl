import 'package:flutter/material.dart';

import 'view/screen/HomeScreen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Helios Access Control Demo',
      home: HomeScreen(),
    );
  }
}


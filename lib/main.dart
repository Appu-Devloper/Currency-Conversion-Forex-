
import 'package:flutter/material.dart';
import 'package:pocket_forex/screens/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pocket Forex',
        theme: ThemeData(
          fontFamily: '',
          primaryColor: Colors.blue[100],
        ),
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}

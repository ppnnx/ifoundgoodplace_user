import 'package:flutter/material.dart';
import 'package:ifgpdemo/screen/home/home_screen.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:ifgpdemo/screen/main/main_screen.dart';
import 'package:ifgpdemo/screen/register/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
      ),
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}


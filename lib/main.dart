import 'package:flutter/material.dart';
import 'package:ifgpdemo/screen/home/home_screen.dart';
import 'package:ifgpdemo/screen/login/login_screen.dart';
import 'package:ifgpdemo/screen/main/main_screen.dart';
import 'package:ifgpdemo/screen/register/register_screen.dart';
import 'package:ifgpdemo/service/provider/content_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => BookMarkProvider())],
    child: MyApp(),
  ));
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

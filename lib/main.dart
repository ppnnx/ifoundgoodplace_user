import 'package:flutter/material.dart';
import 'package:ifgpdemo/screen/home/home_screen.dart';
import 'package:ifgpdemo/service/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // var id = preferences.getInt('id');
  // var email = preferences.getString('email');
  // id == null ? print('no login') : print(id.toString());
  // email == null ? print('no login') : print(email);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        title: 'Flutter Demo',
        home: HomeScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

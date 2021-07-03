// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ifgpdemo/screen/home/home_screen.dart';
// import 'package:ifgpdemo/screen/map/map_screen.dart';
// import 'package:ifgpdemo/screen/profile/profile_screen.dart';
// import 'package:ifgpdemo/screen/rank/rank_screen.dart';
// import 'package:ifgpdemo/screen/shelf/shelf_screen.dart';

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   var _selectedIndex = 0;
//   var pages = [
//     HomeScreen(),
//     RankScreen(),
//     ShelfScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         backgroundColor: Colors.white,
//         onTap: (value) {
//           setState(() {
//             _selectedIndex = value;
//           });
//         },
//         iconSize: 19,
//         selectedFontSize: 10,
//         unselectedFontSize: 10,
//         showUnselectedLabels: false,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(CupertinoIcons.home), label: 'home'),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.star), label: 'ranking'),
//           // BottomNavigationBarItem(
//           //   icon: Icon(CupertinoIcons.map), label: 'map'),
//           BottomNavigationBarItem(
//               icon: Icon(CupertinoIcons.bookmark), label: 'shelf'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.face), label: 'you'),
//         ],
//       ),
//     );
//   }
// }

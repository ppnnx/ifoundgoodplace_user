// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:ifgpdemo/model/content_model.dart';
// import 'package:ifgpdemo/model/db_bookmark.dart';
// import 'package:ifgpdemo/model/user_model.dart';

// class BookMarkProvider with ChangeNotifier {
//   List<Contents?> contentList = [];

//   int get count => contentList.length;
//   List<Contents?> get content => contentList;

//   void addItem(Contents? item) {
//     contentList.add(item);
//     saveData();
//     notifyListeners();
//   }

//   void removeItem(Contents? item) {
//     contentList.remove(item);
//     saveData();
//     notifyListeners();
//   }

//   void saveData() async {
//     List<String> bookmarkList =
//         contentList.map((item) => json.encode(item!.toJson())).toList();
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     sharedPreferences.setStringList('contentList', bookmarkList);
//   }

//   void loadData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     List<String>? bookmarkList = sharedPreferences.getStringList('contentList');
//     if (bookmarkList != null) {
//       contentList = bookmarkList
//           .map((item) => Contents.fromJson(json.decode(item)))
//           .toList();
//     }
//   }
// }

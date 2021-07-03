import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ifgpdemo/model/content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkProvider with ChangeNotifier {
  List<Contents> content = [];

  // add item
  void addItem(Contents _content) {
    content.add(_content);
    updateSharedPreferences();
    notifyListeners();
  }

  // remove item
  void removeItem(Contents _content) {
    content.removeWhere((item) => item.idcontent == _content.idcontent);
    updateSharedPreferences();
    notifyListeners();
  }

  int getContentLength() {
    return content.length;
  }

  Future updateSharedPreferences() async {
    List<String> myContent =
        content.map((f) => json.encode(f.toJson())).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('content', myContent);
  }

  Future syncDataWithProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList('content');

    if (result != null) {
      content = result.map((f) => Contents.fromJson(json.decode(f))).toList();
    }

    notifyListeners();
  }
}

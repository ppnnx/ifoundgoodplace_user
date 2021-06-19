import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/category_model.dart';

class CatergoriesAPI {
  static Future<List<Categories>> getCatergories() async {
    var url = Uri.parse("http://35.213.159.134/category.php?plus");
    var response = await http.get(url);
    // print('category : ${response.body}');

    if (response.statusCode == 200) {
      final List catergory = json.decode(response.body);

      return catergory.map((json) => Categories.fromJson(json)).toList();
    } else {
      throw Exception('error');
    }
  }
}

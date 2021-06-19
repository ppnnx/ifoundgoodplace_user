import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/category_model.dart';

class CategoryTrendingAPI {
  static Future<List<Categories>> getTrendingCategory(String id) async {
    var url = Uri.parse(
        'http://35.213.159.134/rankingbycategory.php?rankbycategory=$id');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) => Categories.fromJson(json)).toList();
    } else {
      throw Exception('error');
    }
  }
}

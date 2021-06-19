import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/content_model.dart';


class ContentAPI {
  static Future<List<Contents>> fetchData() async {
    final url = Uri.parse('http://35.213.159.134/ctall.php?home');
    final response = await http.get(url);
    // print('contents : ${response.body}');

    if (response.statusCode == 200) {
      final List contents = json.decode(response.body);

      return contents.map((data) => Contents.fromJson(data)).toList();
    } else {
      throw Exception("Request API Error");
    }
  }
}

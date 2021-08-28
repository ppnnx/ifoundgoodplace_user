import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/content_model.dart';

class SearchAPI {
  static Future<List<Contents>> searchContent(String query) async {
    try {
      final url = Uri.parse('http://35.213.159.134/ctall.php?home');
      final response = await http.get(url);
      // print("body : ${response.body}");

      if (response.statusCode == 200) {
        final List contents = json.decode(response.body);

        return contents.map((json) => Contents.fromJson(json)).where((content) {
          final searchtitle = content.title.toLowerCase();
          final searchauthor = content.username.toLowerCase();
          final searchquery = query.toLowerCase();

          return searchtitle.contains(searchquery) ||
              searchauthor.contains(searchquery);
        }).toList();
      } else {
        throw Exception();
      }
    } catch (e) {}
    return [];
  }
}

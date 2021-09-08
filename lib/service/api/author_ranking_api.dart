import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifgpdemo/model/author_trending_model.dart';

class AuthorTrendingAPI {
  static Future<List<AuthorTrendingModel>?> getTrendingAuthor() async {
    try {
      var url = Uri.parse('http://35.213.159.134/rankingbyuser.php?rankbyuser');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List authortrending = json.decode(response.body);

        return authortrending
            .map((json) => AuthorTrendingModel.fromJson(json))
            .toList();
      } else {
        throw Exception('request api error');
      }
    } catch (e) {}
    return null;
  }
}

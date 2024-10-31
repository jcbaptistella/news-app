import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/model/NewsResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticlesService {
    Future<List<NewsArticle>> getArticles(String query, {int page = 1, int limit = 10}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final url = Uri.parse('https://newsmicroservice-60t5ut6g.b4a.run/news-rest-api/news/search');

    final body = json.encode({
      'query': query,
      'page': page,
      'country': "br",
      'language': "pt-br",
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

    if (response.statusCode == 200) {
      // Use utf8.decode para garantir que a resposta seja interpretada corretamente
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((article) => NewsArticle.fromJson(article))
          .toList();
    } else {
      return Future.error('Não foi possível buscar as notícias');
    }
    } catch (e) {
      return Future.error('Não foi possível buscar as notícias: ${e.toString()}');
    }
  }
}

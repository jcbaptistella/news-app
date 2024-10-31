import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/model/LoginResponse.dart';

class AuthService {
  final String apiUrl = "https://newsmicroservice-60t5ut6g.b4a.run/news-rest-api/oauth/token";

  Future<LoginResponse?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': email,
          'password': senha,
        }),
      );

      // Verifica se a resposta da API foi bem-sucedida
      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        print('Erro: Status code ${response.statusCode}');
        return null; // Retorna null se houve erro
      }
    } catch (e) {
      print('Erro ao realizar login: $e');
      return null; // Retorna null em caso de exceção
    }
  }
}

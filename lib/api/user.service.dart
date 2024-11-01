import 'dart:convert';
import 'package:news/api/custom.httpclient.dart';
import 'package:news/model/CreateResponse.dart';
import 'package:news/model/UserResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  CustomHttpClient customHttpClient = CustomHttpClient();
  final String apiUrl = "https://newsmicroservice-60t5ut6g.b4a.run/news-rest-api/users";

  Future<CreateUserResponse> createUser(
      String email, String senha, String phoneNumber, String name) async {
    try {
      final response = await customHttpClient.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'username': email,
          'password': senha,
          'phoneNumber': phoneNumber,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        return CreateUserResponse(true, "Usuário criado com sucesso!");
      } else if (response.statusCode == 409) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['code'] == 'EMAIL_ALREADY_EXISTS') {
          return CreateUserResponse(false, 'E-mail já cadastrado.');
        }
      }

      return CreateUserResponse(false, 'Erro ao criar usuário.');
    } catch (e) {
      return CreateUserResponse(false, 'Erro ao criar usuário: $e');
    }
  }

  Future<UserResponse> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? username = prefs.getString('username');

    final url = Uri.parse('https://newsmicroservice-60t5ut6g.b4a.run/news-rest-api/users/$username');

    try {
      final response = await customHttpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserResponse.fromJson(data);
      } else {
        throw Exception('Erro ao buscar os dados do usuário');
      }
    } catch (e) {
      throw Exception('Erro ao buscar os dados do usuário: $e');
    }
  }
}

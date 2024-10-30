import 'package:flutter/material.dart';
import 'package:news/model/LoginResponse.dart';
import 'package:news/pages/create_account_page.dart';
import 'package:news/pages/form/LoginForm.dart';
import 'package:news/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth.service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isLoginAttempted = false; // Novo estado

  void _validateFields() {
    setState(() {
      _isEmailValid = _isEmail(_emailController.text);
      _isPasswordValid = _senhaController.text.isNotEmpty;
    });
  }

  bool _isEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              // Logotipo ou Ícone da Aplicação
              Column(
                children: [
                  Icon(
                    Icons.newspaper,
                    color: Colors.blue[600],
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Faça login para continuar',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Usando o LoginForm
              LoginForm(
                emailController: _emailController,
                senhaController: _senhaController,
                onValidate: (_) => _validateFields(),
              ),
              const SizedBox(height: 30),

              // Mensagem de erro (se necessário)
              if (_isLoginAttempted && (!_isEmailValid || !_isPasswordValid))
                const Text(
                  "Por favor, insira um e-mail válido e a senha.",
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 10),

              // Botão Entrar
              _buildActionButton(
                label: 'Entrar',
                onPressed: () {
                  setState(() {
                    _isLoginAttempted = true; // Marcar que o login foi tentado
                  });

                  // Apenas tenta o login se os campos são válidos
                  if (_isEmailValid && _isPasswordValid) {
                    _login();
                  }
                },
              ),
              const SizedBox(height: 10),

              // Botão Criar Conta
              _buildActionButton(
                label: 'Criar conta',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final senha = _senhaController.text;

    LoginResponse? loginResponse =
        await _authService.login(email, senha);

    if (loginResponse != null) {
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();
      await prefs.setString('accessToken', loginResponse.accessToken);
      await prefs.setString('username', email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuário ou senha inválido"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Função para criar o botão estilizado
  Widget _buildActionButton({required String label, required VoidCallback? onPressed}) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 68, 114, 241),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

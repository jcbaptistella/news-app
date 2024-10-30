import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final ValueChanged<bool> onValidate;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.senhaController,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de E-mail
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "E-mail",
            prefixIcon: const Icon(Icons.email),
            labelStyle: const TextStyle(color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: (value) => onValidate(_isEmail(value)),
        ),
        const SizedBox(height: 20),

        // Campo de Senha
        TextFormField(
          controller: senhaController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Senha",
            prefixIcon: const Icon(Icons.lock),
            labelStyle: const TextStyle(color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: (value) => onValidate(value.isNotEmpty),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  bool _isEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }
}

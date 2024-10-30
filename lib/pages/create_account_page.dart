import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:news/model/CreateResponse.dart';
import '../api/user.service.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final UserService _userService = UserService();

  final MaskTextInputFormatter _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  final _formKey =
      GlobalKey<FormState>(); // Adicionei uma chave global para o formulário

  // Variáveis para rastrear o estado dos campos
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Adicionei listeners para os controladores de texto
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _senhaController.addListener(_updateButtonState);
    _phoneNumberController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _senhaController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // Remova os listeners ao destruir o estado
    _nameController.removeListener(_updateButtonState);
    _emailController.removeListener(_updateButtonState);
    _senhaController.removeListener(_updateButtonState);
    _phoneNumberController.removeListener(_updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: const Text(
          'Criar Conta',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(40),
        child: Form(
          // Adicionei um Form
          key: _formKey, // Atribuí a chave ao formulário
          child: ListView(
            children: [
              const Icon(
                Icons.person_add,
                color: Color.fromARGB(255, 68, 114, 241),
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Preencha seus dados para criar uma nova conta.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Campo de Name
              _buildTextField(
                controller: _nameController,
                labelText: "Nome",
                icon: Icons.person,
              ),

              // Campo de E-mail
              _buildTextField(
                controller: _emailController,
                labelText: "E-mail",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // Validação de e-mail
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail.';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),

              // Campo de Senha
              _buildTextField(
                controller: _senhaController,
                labelText: "Senha",
                icon: Icons.lock,
                obscureText: true,
              ),

              // Campo de Número de Telefone
              _buildTextField(
                controller: _phoneNumberController,
                labelText: "Número de Telefone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneMaskFormatter],
              ),
              const SizedBox(height: 30),

              // Botão Salvar
              _buildActionButton(
                label: 'Salvar',
                onPressed: _isButtonEnabled
                    ? () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final email = _emailController.text;
                          final senha = _senhaController.text;
                          final phoneNumber = _phoneNumberController.text;
                          final name = _nameController.text;

                          CreateUserResponse createUserResponse = await _userService.createUser(
                              email, senha, phoneNumber, name);

                          if (createUserResponse.success) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(createUserResponse.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    : null, // Desabilita o botão se _isButtonEnabled for false
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar campo de texto estilizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.black45),
          labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: validator,
      ),
    );
  }

  // Função para criar botão estilizado
  Widget _buildActionButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
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

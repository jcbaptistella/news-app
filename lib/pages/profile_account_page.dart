import 'package:flutter/material.dart';
import 'package:news/api/user.service.dart';
import 'package:news/model/UserResponse.dart';

class ProfileAccountPage extends StatefulWidget {
  const ProfileAccountPage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileAccountPage> {
  final UserService _userService = UserService();
  late Future<UserResponse> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _userService.getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Define o fundo do Scaffold como branco
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.black), // Texto escuro para contraste
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Fundo branco na AppBar
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.black), // Ícones escuros na AppBar
      ),
      body: FutureBuilder<UserResponse>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado disponível.'));
          } else {
            final userData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Informações da Conta',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(height: 30, thickness: 1),
                  Card(
                    color: Colors.white, // Fundo branco no Card
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading:
                          const Icon(Icons.account_circle, color: Colors.blue),
                      title: const Text('Usuário'),
                      subtitle: Text(userData.username),
                    ),
                  ),
                  Card(
                    color: Colors.white, // Fundo branco no Card
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: const Text('Telefone'),
                      subtitle: Text(userData.phoneNumber),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Função para sair ou editar perfil, por exemplo
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color.fromARGB(
                  //         255, 68, 114, 241), // Cor de fundo do botão
                  //     foregroundColor: Colors.white, // Cor do texto em branco
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 32, vertical: 12),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     'Editar Perfil',
                  //   ),
                  // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

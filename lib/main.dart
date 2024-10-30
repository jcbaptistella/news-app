import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news/pages/home_page.dart';
import 'package:news/pages/login_page.dart';
import 'package:news/pages/profile_account_page.dart';
import 'package:news/pages/splash_screen_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Use `home` para definir a tela inicial
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const ProfileAccountPage()
      },
    );
  }
}

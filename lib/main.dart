import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news/pages/home_page.dart';
import 'package:news/pages/login_page.dart';
import 'package:news/pages/profile_account_page.dart';
import 'package:news/pages/splash_screen_page.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyB26blUxztettoxshVTkopupptvoe9_vlU",
  authDomain: "news-b8d1c.firebaseapp.com",
  projectId: "news-b8d1c",
  storageBucket: "news-b8d1c.firebasestorage.app",
  messagingSenderId: "5143857423",
  appId: "1:5143857423:web:fd5e3112047bade394167a",
  measurementId: "G-PMM1606LPD"
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions); // Inicializa o Firebase com as opções
  runApp(MyApp());
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

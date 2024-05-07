import 'package:flutter/material.dart';
import 'package:miniproject/app/home/home.dart';
import 'package:miniproject/app/modules/splash/splash_screen.dart';
import 'package:miniproject/app/register/register.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCTuz_PKmr4_i8Z7a4eShaIFKXKxcm8xss",
      appId: "1:77397697429:android:e8a69a5b89dfdf287a4c9c",
      messagingSenderId: "77397697429",
      projectId: "mini-project-lx",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Argument yang bisa diterima berdasarkan kebutuhan
    String initialRoute = 'splash'; // Misalnya, 'splash', 'home', atau 'signup'
    
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Tentukan halaman awal berdasarkan nilai initialRoute
      initialRoute: initialRoute,
      routes: {
        'splash': (context) => SplashScreen(),
        'home': (context) => HomePage(),
        'signup': (context) => SignUpPage(),
      },
    );
  }
}

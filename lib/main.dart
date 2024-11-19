//~~~ Made by Riko Gunawan ~~~
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:myapp/main_widget.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
// import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riko',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 69, 163, 240),
        primaryColorLight: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(33, 150, 243, 1),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.titilliumWebTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}

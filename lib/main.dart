import 'package:flutter/material.dart';
// Importamos o nosso ecrã principal que tem a barra de navegação
import 'screens/MainScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia Turístico Coimbra',
      debugShowCheckedModeBanner: false, // Remove a etiqueta "Debug" do canto
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Aqui definimos que o primeiro ecrã da app é o MainScreen
      home: const MainScreen(),
    );
  }
}
import 'package:flutter/material.dart';

import 'categoria_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Controla qual o separador ativo

  // 1. Removemos o 'final' e a lista imediata para a podermos inicializar no initState
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // 2. Inicializamos a lista aqui. 
    // Passamos uma função (callback) para a HomeScreen que chama o nosso _onItemTapped
    _screens = [
      HomeScreen(onVerCategorias: () => _onItemTapped(1)), 
      const CategoriaScreen(),
      const FavoritesScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o estado e reconstrói o ecrã [cite: 1793]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Mostra o widget correspondente ao índice
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
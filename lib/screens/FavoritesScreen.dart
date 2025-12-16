import 'package:flutter/material.dart';
import '../data/DataManager.dart';
import '../models/PontoInteresse.dart';
import 'DetailScreen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Variável para forçar a reconstrução do FutureBuilder quando voltamos do detalhe
  Key _refreshKey = UniqueKey();

  void _refreshList() {
    setState(() {
      _refreshKey = UniqueKey(); // Mudar a chave força o FutureBuilder a correr de novo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos ❤️'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<PontoInteresse>>(
        key: _refreshKey, // Importante para o refresh funcionar
        future: DataManager().getFavoritePoints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<PontoInteresse> favorites = snapshot.data!;

            if (favorites.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.heart_broken, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Ainda não tens favoritos.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final point = favorites[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/${point.image}'),
                  ),
                  title: Text(point.name),
                  subtitle: Text(point.averagePrice), // Mostra o preço, por exemplo
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navega para o detalhe e espera que o utilizador volte
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(point: point),
                      ),
                    ).then((_) {
                      // Quando voltar, atualiza a lista (caso tenha removido o favorito)
                      _refreshList();
                    });
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Sem dados.'));
          }
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/point_interess.dart';
import '../services/favorite_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _favoriteService = FavoriteService();
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
        future: _favoriteService.getFavoritePoints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Erro: ${snapshot.error}'),
              ),
            );
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

            return LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 600;

                return ListView.separated(
                  padding: EdgeInsets.all(isWideScreen ? 16.0 : 8.0),
                  itemCount: favorites.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final point = favorites[index]; // Ponto de interesse atual
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWideScreen ? 800 : double.infinity,
                      ),
                      child: Card( // Card para dar sombra ao item
                        elevation: 1,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(isWideScreen ? 16.0 : 12.0),
                          leading: ClipRRect( // ClipRRect para limitar o tamanho da imagem
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset('assets/${point.image}', // Imagem do ponto de interesse
                              width: isWideScreen ? 80 : 60,
                              height: isWideScreen ? 80 : 60,
                              fit: BoxFit.cover, // Para manter a proporção da imagem
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: isWideScreen ? 80 : 60,
                                  height: isWideScreen ? 80 : 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported), // Icone de erro
                                );
                              },
                            ),
                          ),
                          title: Text(
                            point.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isWideScreen ? 18 : 16,
                            ),
                          ),
                          subtitle: Text(
                            point.averagePrice,
                            style: TextStyle(fontSize: isWideScreen ? 15 : 14),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () { // Ao clicar no item
                            Navigator.push(
                              context,
                              MaterialPageRoute( // Navegação para o detalhe
                                builder: (context) => DetailScreen(point: point), // Passa o ponto de interesse
                              ),
                            ).then((_) { // Depois de voltar do detalhe...
                              _refreshList(); // ... atualiza a lista
                            });
                          },
                        ),
                      ),
                    );
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
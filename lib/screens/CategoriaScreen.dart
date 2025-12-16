import 'package:flutter/material.dart';
import '../data/DataManager.dart';
import '../models/categoria.dart';
import 'PointListScreen.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias Turísticas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // O FutureBuilder gere os estados de espera/sucesso/erro
      body: FutureBuilder<List<Categoria>>(
        future: DataManager().getCategories(), // Chamamos a função que lê o JSON
        builder: (context, snapshot) {

          // 1. Ainda está a carregar?
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Deu erro?
          else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          // 3. Temos dados?
          else if (snapshot.hasData) {
            final List<Categoria> categories = snapshot.data!;

            // Construímos a lista visualmente
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.travel_explore, color: Colors.blue),
                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PointsListScreen(category: category),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Sem dados disponíveis.'));
          }
        },
      ),
    );
  }
}
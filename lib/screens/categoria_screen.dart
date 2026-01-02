import 'package:flutter/material.dart';
import '../data/data_manager.dart';
import '../models/category.dart';
import '../models/icon_mapper.dart';
import 'point_list_screen.dart';

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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: LayoutBuilder(
          key: ValueKey(MediaQuery
              .of(context)
              .orientation),
          builder: (context, constraints) {
            return Stack(
              children: [
                // Imagem de fundo com transparência
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1, // Ajusta a transparência (0.0 a 1.0)
                    child: Image.asset(
                      'assets/imagens/category_background.jpg',
                      // Coloca o caminho da tua imagem
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors
                            .grey[100]); // Fallback se a imagem falhar
                      },
                    ),
                  ),
                ),
                FutureBuilder<List<Categoria>>(
                  future: DataManager().getCategories(),
                  // Chamamos a função que lê o JSON
                  builder: (context, snapshot) {
                    // 1. Ainda está a carregar?
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    // 2. Deu erro?
                    else if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          //serve para dar espaço ao texto
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 60,
                                  color: Colors.red),
                              const SizedBox(height: 10),
                              const Text(
                                'Erro ao carregar categorias',
                                style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );

                      // 3. Temos dados?
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final List<Categoria> categories = snapshot.data!;

                      // Construímos a lista visualmente
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          bool isLandscape = MediaQuery
                              .of(context)
                              .orientation == Orientation.landscape;

                          // Define número de colunas baseado na largura
                          int crossAxisCount = constraints.maxWidth > 600
                              ? 3
                              : 2;

                          // Ajusta o aspect ratio conforme a orientação
                          double childAspectRatio = isLandscape
                              ? 1.5
                              : 1.2;

                          return GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // Define o layout
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final IconData categoryIcon = IconMapper
                                  .getIcon(category.icon);

                              return Card(
                                elevation: 4, // Adiciona sombra
                                child: InkWell( // Adiciona interação
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PointsListScreen(
                                                category: category),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: [
                                      Icon(
                                        categoryIcon,
                                        size: isLandscape ? 48 : 64,
                                        // Reduz o ícone em landscape
                                        color: Colors.blueAccent,
                                        semanticLabel: "${category
                                            .name}", // acessibilidade
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        category.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isLandscape ? 14 : 16,
                                          // Reduz o texto em landscape
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open, size: 60,
                                color: Colors.grey),
                            SizedBox(height: 10),
                            Text('Sem categorias disponíveis.'),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
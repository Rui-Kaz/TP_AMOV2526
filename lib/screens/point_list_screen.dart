import 'package:flutter/material.dart';
import '../models/point_interess.dart';
import '../models/category.dart';
import 'detail_screen.dart';

class PointsListScreen extends StatelessWidget {
  // Recebemos a categoria selecionada como parâmetro
  final Categoria category;

  const PointsListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(category.name),
          // O título do ecrã é o nome da categoria (ex: "Monumentos")
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Define se usa layout compacto ou expandido
              bool isWideScreen = constraints.maxWidth > 600;

              return ListView.separated(
                padding: EdgeInsets.all(isWideScreen ? 16.0 : 8.0),
                itemCount: category.points.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final PontoInteresse point = category.points[index];
                  // constrainedbox para limitar o tamanho do item
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWideScreen ? 800 : double.infinity,
                    ),
                    child: Card( // Card para dar sombra ao item
                      elevation: 1,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(
                            isWideScreen ? 16.0 : 8.0),
                        leading: ClipRRect( // ClipRRect para limitar o tamanho da imagem
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset('assets/${point.image}',
                            // Imagem do ponto de interesse
                            width: isWideScreen ? 100 : 80,
                            height: isWideScreen ? 100 : 80,
                            fit: BoxFit.cover,
                            // Para manter a proporção da imagem
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: isWideScreen ? 100 : 80,
                                height: isWideScreen ? 100 : 80,
                                color: Colors.grey[300],
                                child: const Icon(
                                    Icons.image_not_supported, size: 32),
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
                          point.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // Trunca o texto se ultrapassar
                          style: TextStyle(fontSize: isWideScreen ? 15 : 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(point: point),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
    );
  }
}
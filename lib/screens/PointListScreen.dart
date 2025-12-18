import 'package:flutter/material.dart';
import '../models/PontoInteresse.dart';
import '../models/categoria.dart';
import 'DetailScreen.dart';

class PointsListScreen extends StatelessWidget {
  // Recebemos a categoria selecionada como parâmetro
  final Categoria category;

  const PointsListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name), // O título do ecrã é o nome da categoria (ex: "Monumentos")
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: category.points.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final PontoInteresse point = category.points[index];

          return ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            // Mostramos a imagem do lado esquerdo
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/${point.image}', // Constrói o caminho: assets/imagens/foto.jpg
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
            ),
            title: Text(
              point.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              point.shortDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Corta o texto se for muito grande
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
          );
        },
      ),
    );
  }
}
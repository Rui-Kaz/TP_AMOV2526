import 'package:flutter/material.dart';
import '../models/PontoInteresse.dart';
import '../data/DataManager.dart';

class DetailScreen extends StatefulWidget {
  final PontoInteresse point;

  const DetailScreen({super.key, required this.point});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFav = false; // Controla o estado visual do coração

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  // Verifica se este local já estava nos favoritos ao abrir o ecrã
  void _checkFavoriteStatus() async {
    bool favStatus = await DataManager().isFavorite(widget.point.id);
    setState(() {
      _isFav = favStatus;
    });
  }

  // Função chamada quando se clica no coração
  void _onFavoritePressed() async {
    // Chama o DataManager para atualizar a memória
    bool newStatus = await DataManager().toggleFavorite(widget.point.id);

    // Atualiza o ícone no ecrã
    setState(() {
      _isFav = newStatus;
    });

    // Feedback visual para o utilizador
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus ? 'Adicionado aos Favoritos ❤️' : 'Removido dos Favoritos'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparente ou com título
      appBar: AppBar(
        title: Text(widget.point.name),
      ),
      // Botão Flutuante (FAB) para os favoritos - Requisito muito comum em Android
      floatingActionButton: FloatingActionButton(
        onPressed: _onFavoritePressed,
        backgroundColor: Colors.white,
        child: Icon(
          _isFav ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
          size: 30,
        ),
      ),
      body: SingleChildScrollView( // Permite fazer scroll se o texto for grande
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGEM GRANDE
            Image.asset(
              'assets/${widget.point.image}',
              width: double.infinity, // Ocupa a largura toda
              height: 250,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. TÍTULO E PREÇO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.point.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.point.averagePrice,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 3. INFORMAÇÕES (Horário e Localização)
                  _buildInfoRow(Icons.access_time, 'Horário:', widget.point.schedule),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, 'Local:', widget.point.location),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // 4. DESCRIÇÃO COMPLETA
                  const Text(
                    "Sobre",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.point.description,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),

                  // Espaço extra no fundo para o botão não tapar o texto
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pequeno widget auxiliar para evitar repetição de código
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
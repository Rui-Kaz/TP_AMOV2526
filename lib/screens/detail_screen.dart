import 'package:flutter/material.dart';
import '../models/point_interess.dart';
import '../services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final PontoInteresse point;

  const DetailScreen({super.key, required this.point});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  bool _isFav = false; // Controla o estado visual do coração

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  // Verifica se este local já estava nos favoritos ao abrir o ecrã
  void _checkFavoriteStatus() async {
    bool favStatus = await _favoriteService.isFavorite(widget.point.id);
    setState(() {
      _isFav = favStatus;
    });
  }

  // Função chamada quando se clica no coração
  void _onFavoritePressed() async {
    // Chama o DataManager para atualizar a memória
    bool newStatus = await _favoriteService.toggleFavorite(widget.point.id);

    // Atualiza o ícone no ecrã
    setState(() {
      _isFav = newStatus;
    });

    // Feedback visual para o utilizador
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus ? 'Adicionado aos Favoritos!' : 'Removido dos Favoritos',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.point.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFavoritePressed,
        backgroundColor: Colors.white,
        child: Icon(
          _isFav ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
          size: 30,
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            ),
          );
        },
        child: OrientationBuilder(
          key: ValueKey(MediaQuery.of(context).orientation),
          builder: (context, orientation) {
            // --- 1. DEFINIR A PEÇA DA IMAGEM ---
            final Widget imagem = Image.asset(
              'assets/${widget.point.image}',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            );

            // define peça de conteudo
            final Widget conteudo = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título e Preço
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.point.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.point.averagePrice,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Informações (Horário e Localização)
                  _buildInfoRow(
                    Icons.access_time,
                    'Horário:',
                    widget.point.schedule,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.location_on,
                    'Local:',
                    widget.point.location,
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Descrição Completa
                  const Text(
                    "Sobre",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.point.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),

                  // Espaço extra no fundo para o botão FAB não tapar o texto
                  const SizedBox(height: 80),
                ],
              ),
            );

            // montar o layout
            if (orientation == Orientation.portrait) {
              // modo portrait: Coluna Simples
              return SingleChildScrollView(
                child: Column(children: [imagem, conteudo]),
              );
            } else {
              // modo landscape: Split View (Lado a Lado)
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded obriga a imagem a ocupar 50% da largura (flex: 1)
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: double.infinity, // Ocupa a altura toda disponível
                      child: imagem,
                    ),
                  ),
                  // Expanded obriga o texto a ocupar os outros 50%
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      // Scroll independente para o texto
                      child: conteudo,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // Widget auxiliar para as linhas de informação
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}

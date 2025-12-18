import 'PontoInteresse.dart';

class Categoria {
  final String name;
  final List<PontoInteresse> points;

  Categoria({
    required this.name,
    required this.points,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    // 1. Obtem a lista raw do JSON
    var list = json['points'] as List;

    // 2. Converte cada item dessa lista num objeto PontoInteresse
    List<PontoInteresse> pointsList = list.map((i) => PontoInteresse.fromJson(i)).toList();

    return Categoria(
      name: json['name'],
      points: pointsList, // Guarda a lista convertida
    );
  }
}
import 'PontoInteresse.dart';

class Categoria {
  final String name;
  final List<PontoInteresse> points;

  Categoria({
    required this.name,
    required this.points,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    // 1. Obtemos a lista bruta do JSON
    var list = json['points'] as List;

    // 2. Convertemos cada item dessa lista num objeto PontoInteresse
    List<PontoInteresse> pointsList = list.map((i) => PontoInteresse.fromJson(i)).toList();

    return Categoria(
      name: json['name'],
      points: pointsList, // Guardamos a lista convertida
    );
  }
}
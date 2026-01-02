import 'point_interess.dart';

class Categoria {
  final String name;
  final String icon;
  final List<PontoInteresse> points;

  Categoria({
    required this.name,
    this.icon = 'travel_explore',
    required this.points,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    // Obtem a lista raw do JSON
    var list = json['points'] as List;

    // Converte cada item dessa lista num objeto PontoInteresse
    List<PontoInteresse> pointsList = list.map((i) => PontoInteresse.fromJson(i)).toList();

    return Categoria(
      name: json['name'],
      icon: json['icon'],
      points: pointsList, // Guarda a lista convertida
    );
  }
}
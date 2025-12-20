class Cidade {
  final int id;
  final String name;

  Cidade({
    required this.id,
    required this.name,
  });

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      id: json['cityId'],
      name: json['cityName'],
    );
  }
}

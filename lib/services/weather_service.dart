import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class WeatherService {
  // Metodo para obter os dados meteorológicos do IPMA
  Future<WeatherData> getWeather(int cityId) async {
    final String url = 'https://api.ipma.pt/open-data/forecast/meteorology/cities/daily/$cityId.json';

    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final previsaoHoje = data['data'][0];

        return WeatherData(
          temperature: previsaoHoje['tMax'].toString(),
          weatherCode: previsaoHoje['idWeatherType'],
        );
      } else {
        throw Exception('Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao obter meteorologia: $e');
    }
  }

  // Metodo auxiliar para obter o ícone do tempo
  static IconData getWeatherIcon(int code) {
    if (code == 1) return Icons.wb_sunny;
    if (code >= 2 && code <= 5) return Icons.cloud_outlined;
    if (code >= 6 && code <= 15) return Icons.water_drop;
    if (code >= 19 && code <= 23) return Icons.ac_unit;
    if (code >= 24 && code <= 27) return Icons.flash_on;
    return Icons.help_outline;
  }

  // Metodo auxiliar para obter a descrição do tempo
  static String getWeatherDescription(int code) {
    if (code == 1) return 'Céu limpo';
    if (code >= 2 && code <= 5) return 'Nublado';
    if (code >= 6 && code <= 15) return 'Chuva';
    if (code >= 19 && code <= 23) return 'Neve';
    if (code >= 24 && code <= 27) return 'Trovoada';
    return 'Indisponível';
  }
}

// Classe modelo para encapsular os dados do clima
class WeatherData {
  final String _temperature;
  final int _weatherCode;

  WeatherData({
    required String temperature,
    required int weatherCode,
  })  : _temperature = temperature,
        _weatherCode = weatherCode;

  // Getters para acesso controlado
  String get temperature => _temperature;
  int get weatherCode => _weatherCode;
}

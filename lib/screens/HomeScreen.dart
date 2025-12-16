import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CategoriaScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _temperature = '';
  int _weatherCode = 0;
  bool _isLoading = true;
  bool _fetchingData = false;

  @override
  void initState() {
    super.initState();
    _getWeather(); // Chamamos a API assim que o ecrã inicia
  }

  Future<void> _getWeather() async {
    print("--- A INICIAR PEDIDO METEOROLOGIA ---");
    // URL da API para Coimbra
    const String url = 'https://api.open-meteo.com/v1/forecast?latitude=40.2033&longitude=-8.4103&current_weather=true';

    try {
      // 1. Fazer o pedido HTTP (GET)
      final http.Response response = await http.get(Uri.parse(url));
      // O que falta aqui? Lembra-te de usar o await e o http.get
      print("Status Code: ${response.statusCode}");
      print("Resposta: ${response.body}");

      // 2. Verificar se o pedido correu bem (statusCode 200) [cite: 590]
      if (response.statusCode == HttpStatus.ok) {

        // 3. Converter o corpo da resposta (body) de JSON para Mapa [cite: 593]
        final data = json.decode(response.body);

        // 4. Atualizar o estado com a temperatura (setState) [cite: 139]
        setState(() {
          // Guardamos a temperatura
          _temperature = data['current_weather']['temperature'].toString();

          // Guardamos o código (agora é importante!)
          // O API pode enviar int ou double, o toInt() garante que é inteiro
          int code = data['current_weather']['weathercode'].toInt();

          // Guardamos o código numa variável nova (tens de a criar lá em cima!)
          _weatherCode = code;

          _isLoading = false;
        });
          print("--- DADOS ATUALIZADOS COM SUCESSO ---");
        } else {
          print("--- ERRO NO SERVIDOR: ${response.statusCode} ---");
        }
    } catch (e) {
      print('Erro: $e');
      print('--- ERRO CRÍTICO (CATCH): $e ---');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Traduz o código numérico para um Ícone visual
    IconData _getWeatherIcon(int code) {
      if (code == 0) return Icons.wb_sunny;
      if (code >= 1 && code <= 3) return Icons.wb_cloudy;
      if (code >= 45 && code <= 48) return Icons.foggy; // ou Icons.cloud
      if (code >= 51 && code <= 67) return Icons.water_drop; // Chuva
      if (code >= 71 && code <= 77) return Icons.ac_unit; // Neve
      if (code >= 95) return Icons.flash_on; // Trovoada
      return Icons.help_outline; // Desconhecido
    }

    // Traduz o código numérico para Texto
    String _getWeatherDescription(int code) {
      if (code == 0) return 'Céu limpo';
      if (code >= 1 && code <= 3) return 'Parcialmente nublado';
      if (code >= 45 && code <= 48) return 'Nevoeiro';
      if (code >= 51 && code <= 67) return 'Chuva';
      if (code >= 71 && code <= 77) return 'Neve';
      if (code >= 95) return 'Trovoada';
      return 'Desconhecido';
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Guia de Coimbra',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            // 1. IMAGEM
            // Confirma se o nome do ficheiro "universidade.jpg" existe na tua pasta assets/imagens/
            // Podes ajustar a altura (height) para não ocupar o ecrã todo.
            Image.asset(
              'assets/imagens/universidade.jpg',
              height: 200,
            ),

            const SizedBox(height: 20),

            // 2. NOME DA CIDADE
            const Text(
              'Coimbra',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 3. METEOROLOGIA COMPLETA
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
              children: [
                Icon(
                  _getWeatherIcon(_weatherCode), // Usa a função de tradução
                  size: 50,
                  color: Colors.orange,
                ),
                Text(
                  '$_temperature°C - ${_getWeatherDescription(_weatherCode)}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 4. BOTÃO
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriaScreen()),
                );
              },
              child: const Text('Ver Categorias'),
            ),
          ],
        ),
      ),
    );
  }
}
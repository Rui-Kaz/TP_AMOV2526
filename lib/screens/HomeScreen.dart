import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/DataManager.dart';
import 'CategoriaScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variáveis para a cidade
  String _cityName = 'A carregar...';
  int? _cityId;

  String _temperature = '';
  int _weatherCode = 0;
  bool _isLoading = true; // Esta variável agora controla o carregamento da cidade + tempo


  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Instancia o DataManager
    DataManager dataManager = DataManager();

    // 1. Vai buscar a informação da cidade ao ficheiro JSON
    final cityInfo = await dataManager.getCityInfo();

    // 2. Guarda a informação no estado do widget
    setState(() {
      _cityName = cityInfo['cityName'] ?? 'Cidade não encontrada';
      _cityId = cityInfo['cityId'];
    });

    // 3. Verifica se temos um ID válido antes de chamar a API de meteorologia
    if (_cityId != null && _cityId != -1) {
      await _getWeather(_cityId!); // Passa o ID para a função de meteorologia
    } else {
      // Se não houver ID, paramos o carregamento para não dar erro na API
      setState(() {
        _isLoading = false;
        _temperature = 'N/A';
        _weatherCode = -1; // Usar um código de erro
      });
      print("--- ERRO: ID da cidade não encontrado no ficheiro JSON. ---");
    }
  }

  Future<void> _getWeather(int idCidade) async {
    print("--- A INICIAR PEDIDO METEOROLOGIA ---");
    // URL da API para Coimbra
    //const String url = 'https://api.open-meteo.com/v1/forecast?latitude=40.2033&longitude=-8.4103&current_weather=true';

    //IPMA
    final String url = 'https://api.ipma.pt/open-data/forecast/meteorology/cities/daily/$idCidade.json';
    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // O IPMA devolve uma lista chamada "data".
        // O índice [0] é a previsão de hoje.
        final previsaoHoje = data['data'][0];

        setState(() {
          // A temperatura máxima vem como String no campo 'tMax'
          _temperature = previsaoHoje['tMax'].toString();

          // O código do tempo (chuva, sol) vem em 'idWeatherType'
          _weatherCode = previsaoHoje['idWeatherType'];

          _isLoading = false;
        });

        print("--- DADOS METEOROLÓGICOS ATUALIZADOS COM SUCESSO ---");
      } else {
        print("--- ERRO NO SERVIDOR DE METEOROLOGIA: ${response.statusCode} ---");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('--- ERRO CRÍTICO (CATCH) AO OBTER METEOROLOGIA: $e ---');
      setState(() => _isLoading = false);
    }
  }


  IconData _getWeatherIcon(int code) {
    if (code == 1) return Icons.wb_sunny; // Céu limpo
    if (code >= 2 && code <= 5) return Icons.cloud_outlined; // Nublado
    if (code >= 6 && code <= 15) return Icons.water_drop; // Chuva
    if (code >= 19 && code <= 23) return Icons.ac_unit; // Neve
    if (code >= 24 && code <= 27) return Icons.flash_on; // Trovoada
    return Icons.help_outline; // Desconhecido ou N/A
  }

  String _getWeatherDescription(int code) {
    if (code == 1) return 'Céu limpo';
    if (code >= 2 && code <= 5) return 'Nublado';
    if (code >= 6 && code <= 15) return 'Chuva';
    if (code >= 19 && code <= 23) return 'Neve';
    if (code >= 24 && code <= 27) return 'Trovoada';
    return 'Indisponível';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OrientationBuilder(
            builder: (context, orientation) {
              // --- COMPONENTE DA IMAGEM ---
              final Widget imagem = Image.asset(
                'assets/imagens/$_cityName.jpg',
                height: orientation == Orientation.portrait ? 200 : double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              );

              // --- COMPONENTE DO CONTEÚDO ---
              final Widget conteudo = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Guia de $_cityName',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _cityName,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                    children: [
                      Icon(
                        _getWeatherIcon(_weatherCode),
                        size: 50,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_temperature°C - ${_getWeatherDescription(_weatherCode)}',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
              );

              // --- LAYOUT CONSOANTE A ORIENTAÇÃO ---
              if (orientation == Orientation.portrait) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        imagem,
                        const SizedBox(height: 30),
                        conteudo,
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: imagem,
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: conteudo,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
        ),
    );
  }
}
import 'package:flutter/material.dart';
import '../data/data_manager.dart';
import '../models/city.dart';
import '../services/weather_service.dart';
import 'categoria_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Cidade? _cidade;
  WeatherData? _weatherData;
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = true; // Esta variável agora controla o carregamento da cidade + tempo


  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // Carrega os dados da cidade usando o DataManager
      _cidade = await DataManager().getCityInfo();

      // Guarda a informação no estado do widget
      setState(() {});

      // Verifica se temos um ID válido antes de chamar a API de meteorologia
      if (_cidade != null && _cidade!.id != -1) {
        try {
          _weatherData = await _weatherService.getWeather(_cidade!.id);
        } catch (weatherError) {
          print("Erro ao obter meteorologia: $weatherError");
          // Mantém _weatherData como null, o que ativa o fallback na UI
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Erro crítico ao carregar dados: $e");
      setState(() {
        _isLoading = false;
        _cidade = Cidade(id: -1, name: 'Erro ao Carregar');
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Mostra loading enquanto não tem dados da cidade
    if (_cidade == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
        body: OrientationBuilder(
            builder: (context, orientation) {
              // --- COMPONENTE DA IMAGEM ---
              final Widget imagem = Image.asset(
                'assets/imagens/${_cidade!.name}.jpg',
                height: orientation == Orientation.portrait ? 200 : double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: orientation == Orientation.portrait ? 200 : double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 64),
                  );
                },
              );

              // --- COMPONENTE DO CONTEÚDO ---
              final Widget conteudo = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Guia de ${_cidade?.name ?? "A carregar..."}',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _cidade!.name,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _weatherData != null
                      ? Column(
                    children: [
                      Icon(
                        WeatherService.getWeatherIcon(_weatherData!.weatherCode),
                        size: 50,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_weatherData!.temperature}°C - ${WeatherService.getWeatherDescription(_weatherData!.weatherCode)}',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ) //caso não consiga obter dados do clima
                  : const Column(
                    children: [
                      Icon(Icons.cloud_off, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Clima indisponível',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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

              // orientação
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
                    Expanded(flex: 1, child: imagem),
                    // Expanded obriga o texto a ocupar os outros 50%
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
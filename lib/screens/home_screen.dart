import 'package:flutter/material.dart';
import '../data/data_manager.dart';
import '../models/city.dart';
import '../services/weather_service.dart';
//import 'categoria_screen.dart';


class HomeScreen extends StatefulWidget {
final VoidCallback onVerCategorias;

  const HomeScreen({super.key, required this.onVerCategorias});

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // Criação do estado do widget
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
      //setState(() {});

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
        _cidade = Cidade(id: -1, name: 'Erro ao Carregar');
    } finally {
      setState(() => _isLoading = false); // Atualiza tudo de uma vez
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
      body: OrientationBuilder( // Detecta a orientação do dispositivo
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.asset(
                isLandscape ? 'assets/imagens/${_cidade?.name ?? "Coimbra"}_landscape.jpg'
                : 'assets/imagens/${_cidade?.name ?? "Coimbra"}.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                        Icons.image_not_supported,
                        size: 64
                    ),
                  );
                },
              ),
              // Título no topo
              Positioned(
                top: isLandscape ? 20 : 60,
                left: isLandscape ? 30 : 0,
                right: isLandscape ? null : 0,
                child: Text(
                  'Guia de ${_cidade?.name ?? "A carregar..."}',
                  style: TextStyle(
                    fontSize: isLandscape ? 28 : 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black87,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: isLandscape ? TextAlign.left : TextAlign.center,
                ),
              ),

              // Card de meteorologia no fundo
              Positioned(
                bottom: isLandscape ? 20 : 80,
                left: 20,
                right: 20,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isLandscape ? 20 : 32),
                    child: _isLoading // Mostra loading enquanto carrega
                    ? const Center(child: CircularProgressIndicator())
                    : _weatherData == null //se não tiver dados de meteorologia
                        // em caso de erro
                        ? const Center(child: Text('Erro ao carregar meteorologia'))
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _cidade!.name,
                            style: TextStyle(
                              fontSize: isLandscape ? 22 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Ícone e temperatura
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              WeatherService.getWeatherIcon(_weatherData?.weatherCode ?? 1060300),
                              size: 48,
                              color: WeatherService.getWeatherColor(_weatherData!.weatherCode),
                              semanticLabel: 'Ícone de meteorologia',
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${_weatherData!.temperature}°C',
                              style: TextStyle(fontSize: isLandscape ? 32 : 40),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Text(
                          WeatherService.getWeatherDescription(_weatherData!.weatherCode),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
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
      body: OrientationBuilder( // Detecta a orientação do dispositivo
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.asset(
                isLandscape ? 'assets/imagens/${_cidade!.name}_landscape.jpg'
                : 'assets/imagens/${_cidade!.name}.jpg',
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
              Positioned( //Se em landscape ou portrait
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
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: widget.onVerCategorias,
                    child: const Text('Ver Categorias'),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isLandscape ? 20 : 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _cidade!.name,
                          style: TextStyle(
                            fontSize: isLandscape ? 20 : 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isLandscape ? 12 : 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : _weatherData != null
                            ? Column(
                          children: [
                            Icon(
                              WeatherService.getWeatherIcon(
                                  _weatherData!.weatherCode),
                              size: isLandscape ? 40 : 50,
                              color: WeatherService.getWeatherColor(_weatherData!.weatherCode),
                              semanticLabel: 'Ícone de meteorologia',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_weatherData!.temperature}°C - ${WeatherService
                                  .getWeatherDescription(
                                  _weatherData!.weatherCode)}',
                              style: TextStyle(
                                fontSize: isLandscape ? 16 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ) // Em caso de
                        : const Column(
                          children: [
                            Icon(
                                Icons.cloud_off,
                                size: 50,
                                color: Colors.grey,
                                semanticLabel: 'Ícone de meteorologia',
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Clima indisponível',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey
                              ),
                            ),
                          ],
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
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../models/point_interess.dart';
import '../models/category.dart';

class DataManager {
  // Localização do ficheiro json
  static const String _filePath = 'assets/data/poi.json';
  static const String _favKey = 'favoritos_ids'; // Chave para guardar no disco

  Future<Cidade> getCityInfo() async {
    try { //carrega o ficheiro json
      final String jsonString = await rootBundle.loadString(_filePath);
      //descodifica a string para um mapa (JSON Object)
      final Map<String, dynamic> decodedData = json.decode(jsonString);
      //retorna o objeto
      return Cidade.fromJson(decodedData);
    } catch (e) {
      print('Erro ao carregar dados da cidade: $e');
      return Cidade(id: -1, name: 'Erro');
    }
  }



  Future<List<Categoria>> getCategories() async {
    try {
      // 1. Carregar o conteúdo do ficheiro como String
      final String jsonString = await rootBundle.loadString(_filePath);

      // 2. Descodificar a String para um Mapa (JSON Object)
      final Map<String, dynamic> decodedData = json.decode(jsonString);

      // 3. Aceder à chave "categories" que é uma lista
      final List<dynamic> categoriesJson = decodedData['categories'];

      // 4. Converter cada item JSON num objeto Categoria
      return categoriesJson.map((json) => Categoria.fromJson(json)).toList();

    } catch (e) {
      print('Erro ao carregar dados: $e');
      return []; // Retorna lista vazia em caso de erro para não "rebentar" a app
    }
  }




  // 1. Obter a lista de IDs favoritos
  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    // Retorna a lista de strings ou uma lista vazia se não existir nada
    return prefs.getStringList(_favKey) ?? [];
  }

  // 2. Adicionar ou Remover um favorito (Toggle)
  Future<bool> toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentFavs = prefs.getStringList(_favKey) ?? [];
    final String idStr = id.toString();

    if (currentFavs.contains(idStr)) {
      currentFavs.remove(idStr); // Se já existe, remove
      await prefs.setStringList(_favKey, currentFavs);
      return false; // Retorna false indicando que já não é favorito
    } else {
      currentFavs.add(idStr); // Se não existe, adiciona
      await prefs.setStringList(_favKey, currentFavs);
      return true; // Retorna true indicando que agora é favorito
    }
  }

  // 3. Verifica se um ID específico é favorito (para pintar o coração)
  Future<bool> isFavorite(int id) async {
    final List<String> currentFavs = await getFavoriteIds();
    return currentFavs.contains(id.toString());
  }

  // 4. Obter a lista completa de objetos PontoInteresse que são favoritos
  Future<List<PontoInteresse>> getFavoritePoints() async {
    // 1. Vamos buscar todos os IDs guardados
    final List<String> favIds = await getFavoriteIds();

    // Se não houver favoritos, poupamos trabalho e retornamos logo vazio
    if (favIds.isEmpty) return [];

    // 2. Vamos buscar todas as categorias (e os seus pontos)
    final List<Categoria> allCategories = await getCategories();

    // 3. Vamos percorrer tudo e encontrar os pontos que coincidem
    List<PontoInteresse> favoritePoints = [];

    for (var category in allCategories) {
      for (var point in category.points) {
        // Se o ID deste ponto estiver na lista de favoritos...
        if (favIds.contains(point.id.toString())) {
          favoritePoints.add(point);
        }
      }
    }

    return favoritePoints;
  }
}
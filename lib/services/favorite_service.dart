import '../data/data_manager.dart';
import '../models/point_interess.dart';

class FavoriteService {
  final DataManager _dataManager = DataManager();

  // Obtém a lista de pontos favoritos
  Future<List<PontoInteresse>> getFavoritePoints() async {
    return await _dataManager.getFavoritePoints();
  }

  // Verifica se um ponto é favorito
  Future<bool> isFavorite(int pointId) async {
    return await _dataManager.isFavorite(pointId);
  }

  // Adiciona ou remove um ponto dos favoritos
  Future<bool> toggleFavorite(int pointId) async {
    return await _dataManager.toggleFavorite(pointId);
  }

  // Obtém apenas os IDs dos favoritos
  Future<List<String>> getFavoriteIds() async {
    return await _dataManager.getFavoriteIds();
  }
}

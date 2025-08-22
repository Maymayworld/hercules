// providers/favorites_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends StateNotifier<Set<int>> {
  static const String _favoritesKey = 'exercise_favorites';

  FavoritesNotifier() : super(<int>{}) {
    _loadFavorites();
  }

  // SharedPreferencesからお気に入りを読み込み
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
      final favoritesSet = favoritesList.map((id) => int.parse(id)).toSet();
      state = favoritesSet;
    } catch (e) {
      print('Failed to load favorites: $e');
      state = <int>{};
    }
  }

  // お気に入りに追加
  Future<void> addFavorite(int exerciseId) async {
    try {
      final newFavorites = Set<int>.from(state);
      newFavorites.add(exerciseId);
      state = newFavorites;
      await _saveFavorites();
    } catch (e) {
      print('Failed to add favorite: $e');
    }
  }

  // お気に入りから削除
  Future<void> removeFavorite(int exerciseId) async {
    try {
      final newFavorites = Set<int>.from(state);
      newFavorites.remove(exerciseId);
      state = newFavorites;
      await _saveFavorites();
    } catch (e) {
      print('Failed to remove favorite: $e');
    }
  }

  // お気に入りの切り替え
  Future<void> toggleFavorite(int exerciseId) async {
    if (state.contains(exerciseId)) {
      await removeFavorite(exerciseId);
    } else {
      await addFavorite(exerciseId);
    }
  }

  // お気に入りかどうかをチェック
  bool isFavorite(int exerciseId) {
    return state.contains(exerciseId);
  }

  // SharedPreferencesに保存
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = state.map((id) => id.toString()).toList();
      await prefs.setStringList(_favoritesKey, favoritesList);
    } catch (e) {
      print('Failed to save favorites: $e');
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) {
  return FavoritesNotifier();
});
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipez/features/recipes/data/models/recipe_model.dart';
import 'package:recipez/features/auth/data/models/user_model.dart';

class CacheService {
  static const String _recipesKey = 'cached_recipes';
  static const String _usersKey = 'cached_users';
  static const Duration _cacheExpiry = Duration(hours: 24);
  final SharedPreferences _prefs;

  CacheService(this._prefs);

  Future<void> cacheRecipes(List<RecipeModel> recipes) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
    };
    await _prefs.setString(_recipesKey, jsonEncode(data));
  }

  Future<List<RecipeModel>?> getCachedRecipes() async {
    final cachedData = _prefs.getString(_recipesKey);
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = DateTime.parse(data['timestamp']);

    // Verificar si el caché ha expirado
    if (DateTime.now().difference(timestamp) > _cacheExpiry) {
      await _prefs.remove(_recipesKey);
      return null;
    }

    final List<dynamic> recipesJson = data['recipes'];
    return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
  }

  Future<void> clearCache() async {
    await _prefs.remove(_recipesKey);
  }

  Future<void> cacheUser(UserModel user) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'user': user.toJson(),
    };
    await _prefs.setString('${_usersKey}_${user.uid}', jsonEncode(data));
  }

  Future<UserModel?> getCachedUser(String uid) async {
    final cachedData = _prefs.getString('${_usersKey}_$uid');
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = DateTime.parse(data['timestamp']);

    if (DateTime.now().difference(timestamp) > _cacheExpiry) {
      await _prefs.remove('${_usersKey}_$uid');
      return null;
    }

    return UserModel.fromJson(data['user']);
  }

  Future<void> clearUserCache(String uid) async {
    await _prefs.remove('${_usersKey}_$uid');
  }

  Future<void> clearAllCache() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_recipesKey) || key.startsWith(_usersKey)) {
        await _prefs.remove(key);
      }
    }
  }

  Future<void> cacheRecentRecipes(
    List<RecipeModel> recipes,
    String userId,
  ) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
    };
    await _prefs.setString('${_recipesKey}_recent_$userId', jsonEncode(data));
  }

  Future<List<RecipeModel>?> getCachedRecentRecipes(String userId) async {
    final cachedData = _prefs.getString('${_recipesKey}_recent_$userId');
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = DateTime.parse(data['timestamp']);

    if (DateTime.now().difference(timestamp) > _cacheExpiry) {
      await _prefs.remove('${_recipesKey}_recent_$userId');
      return null;
    }

    final List<dynamic> recipesJson = data['recipes'];
    return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
  }

  Future<void> clearRecipeCache(String userId) async {
    await _prefs.remove('${_recipesKey}_recent_$userId');
  }

  Future<void> cachePopularRecipes(
    List<RecipeModel> recipes,
    String userId,
  ) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
    };
    await _prefs.setString('${_recipesKey}_popular_$userId', jsonEncode(data));
  }

  Future<List<RecipeModel>?> getCachedPopularRecipes(String userId) async {
    final cachedData = _prefs.getString('${_recipesKey}_popular_$userId');
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = DateTime.parse(data['timestamp']);

    if (DateTime.now().difference(timestamp) > _cacheExpiry) {
      await _prefs.remove('${_recipesKey}_popular_$userId');
      return null;
    }

    final List<dynamic> recipesJson = data['recipes'];
    return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
  }

  Future<void> cacheSearchResults(
    String query,
    List<RecipeModel> recipes,
  ) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
    };
    await _prefs.setString('${_recipesKey}_search_$query', jsonEncode(data));
  }

  Future<List<RecipeModel>?> getCachedSearchResults(String query) async {
    final cachedData = _prefs.getString('${_recipesKey}_search_$query');
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = DateTime.parse(data['timestamp']);

    // Para las búsquedas usamos un tiempo de caché más corto
    if (DateTime.now().difference(timestamp) > const Duration(hours: 1)) {
      await _prefs.remove('${_recipesKey}_search_$query');
      return null;
    }

    final List<dynamic> recipesJson = data['recipes'];
    return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
  }

  Future<void> clearSearchCache() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('${_recipesKey}_search_')) {
        await _prefs.remove(key);
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/repository/cloud_firestore_api.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreApi = CloudFirestoreAPI();

  Stream<List<RecipeCardModel>> readAllRecipeData(String userId) => _cloudFirestoreApi.readAllData(userId);

  Stream<List<RecipeCardModel>> readFavoritesRecipeData(List<String> favorites) => _cloudFirestoreApi.readFavoritesData(favorites);
  Stream<List<RecipeCardModel>> readMyRecipesData(List<String> myRecipes) => _cloudFirestoreApi.readMyRecipesData(myRecipes);

  Stream<List<RecipeCardModel>> readSearchData(String text, String userId) => _cloudFirestoreApi.readSearchData(text, userId);

  Future<RecipeModel> readRecipeDataById(String id) => _cloudFirestoreApi.readDataById(id);

  Future<void> createRecipeData(RecipeModel recipe, String uid) => _cloudFirestoreApi.createData(recipe, uid);

  void updateRecipeData(RecipeModel recipe) => _cloudFirestoreApi.updateData(recipe);

  void updateLikeRecipeData(int likes, String id, String uid, bool isLiked) => _cloudFirestoreApi.updateLikeData(likes, id, uid, isLiked);
}
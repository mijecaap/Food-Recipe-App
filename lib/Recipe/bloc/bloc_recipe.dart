import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/Recipe/model/ingredient.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/repository/cloud_storage_repository.dart';
import 'package:recipez/Recipe/repository/cloud_firestore_repository.dart';
import 'package:recipez/User/model/user.dart';

class RecipeBloc implements Bloc {

  final _cloudFirestoreRepository = CloudFirestoreRepository();
  final _cloudStorageRepository = CloudStorageRepository();

  // 1. Subir Imagen
  Future<String> uploadImage(File image) {
    return _cloudStorageRepository.uploadRecipeImage(image);
  }

  // 2. Subir receta
  Future<void> createRecipe(RecipeModel recipe, String uid) => _cloudFirestoreRepository.createRecipeData(recipe, uid);
  Future<void> updateRecipe(RecipeModel recipe) => _cloudFirestoreRepository.updateRecipeData(recipe);
  Future<DocumentReference<Object?>> createIngredient(IngredientModel ingredient) => _cloudFirestoreRepository.createIngredientData(ingredient);

  // 3. Leer todas las recetas
  Stream<List<RecipeCardModel>> readAllRecipes(String userId) => _cloudFirestoreRepository.readAllRecipeData(userId);
  Stream<List<RecipeCardModel>> readOrderLikesData(String userId, bool limit) => _cloudFirestoreRepository.readOrderLikesData(userId,limit);
  Stream<List<RecipeCardModel>> readOrderDateData(String userId, bool limit) => _cloudFirestoreRepository.readOrderDateData(userId,limit);
  Stream<List<RecipeCardModel>> readOrderViewsData(String userId, bool limit) => _cloudFirestoreRepository.readOrderViewsData(userId,limit);

  Stream<List<RecipeCardModel>> readFavoritesRecipes(List<String> favorites) => _cloudFirestoreRepository.readFavoritesRecipeData(favorites);
  Stream<List<RecipeCardModel>> readMyRecipes(List<String> myRecipes) => _cloudFirestoreRepository.readMyRecipesData(myRecipes);

  Stream<List<RecipeCardModel>> readSearch(String text, String userId) => _cloudFirestoreRepository.readSearchData(text, userId);
  Future<List<RecipeCardModel>> readSearchIngredients(String name, int value, String dimension, String userId) => _cloudFirestoreRepository.readSearchIngredientData(name, value, dimension, userId);

  // 4. Leer Receta por Id
  Future<RecipeModel> readRecipeById(String id) => _cloudFirestoreRepository.readRecipeDataById(id);
  // Leer Usuario por Id
  Future<UserModel> readUserById(String uid) => _cloudFirestoreRepository.readUserById(uid);
  Future<List<DocumentSnapshot<Object?>>> readIngredientById(List<dynamic> listId) => _cloudFirestoreRepository.readIngredientById(listId);

  // 5. Likear receta
  void updateLikeRecipe(int likes, String id, String uid, bool isLiked) => _cloudFirestoreRepository.updateLikeRecipeData(likes, id, uid, isLiked);

  // 6. Rerportar receta
  void updateReportRecipe(String id, String uid, String text) => _cloudFirestoreRepository.updateReportRecipeData(id, uid, text);

  void updateViews(String id) => _cloudFirestoreRepository.updateViews(id);
  @override
  void dispose() {
    // TODO: implement dispose

  }
}
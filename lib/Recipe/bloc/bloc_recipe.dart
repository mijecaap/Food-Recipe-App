import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/repository/cloud_storage_repository.dart';
import 'package:recipez/Recipe/repository/cloud_firestore_repository.dart';

class RecipeBloc implements Bloc {

  final _cloudFirestoreRepository = CloudFirestoreRepository();
  final _cloudStorageRepository = CloudStorageRepository();

  // 1. Subir Imagen
  Future<String> uploadImage(File image) {
    return _cloudStorageRepository.uploadRecipeImage(image);
  }

  // 2. Subir receta
  Future<void> createRecipe(RecipeModel recipe, String uid) => _cloudFirestoreRepository.createRecipeData(recipe, uid);

  // 3. Leer todas las recetas
  Stream<List<RecipeCardModel>> readAllRecipes(String userId) => _cloudFirestoreRepository.readAllRecipeData(userId);
  Stream<List<RecipeCardModel>> readOrderLikesData(String userId) => _cloudFirestoreRepository.readOrderLikesData(userId);
  Stream<List<RecipeCardModel>> readOrderDateData(String userId) => _cloudFirestoreRepository.readOrderDateData(userId);
  Stream<List<RecipeCardModel>> readOrderViewsData(String userId) => _cloudFirestoreRepository.readOrderViewsData(userId);

  Stream<List<RecipeCardModel>> readFavoritesRecipes(List<String> favorites) => _cloudFirestoreRepository.readFavoritesRecipeData(favorites);
  Stream<List<RecipeCardModel>> readMyRecipes(List<String> myRecipes) => _cloudFirestoreRepository.readMyRecipesData(myRecipes);

  Stream<List<RecipeCardModel>> readSearch(String text, String userId) => _cloudFirestoreRepository.readSearchData(text, userId);

  // 4. Leer Receta por Id
  Future<RecipeModel> readRecipeById(String id) => _cloudFirestoreRepository.readRecipeDataById(id);

  // 5. Likear receta
  void updateLikeRecipe(int likes, String id, String uid, bool isLiked) => _cloudFirestoreRepository.updateLikeRecipeData(likes, id, uid, isLiked);

  @override
  void dispose() {
    // TODO: implement dispose

  }
}
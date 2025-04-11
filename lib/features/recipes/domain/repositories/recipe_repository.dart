import 'package:dartz/dartz.dart';
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';

abstract class RecipeRepository {
  Stream<List<Recipe>> getAllRecipes(String userId);
  Stream<List<Recipe>> getFavoriteRecipes(List<String> favorites);
  Stream<List<Recipe>> getUserRecipes(List<String> myRecipes);
  Stream<List<Recipe>> getRecipesByLikes(String userId, bool limit);
  Stream<List<Recipe>> getRecipesByDate(String userId, bool limit);
  Stream<List<Recipe>> getRecipesByViews(String userId, bool limit);
  Stream<List<Recipe>> searchRecipes(String text, String userId);
  Future<List<Recipe>> searchRecipesByIngredient(
      String name, int value, String dimension, String userId);
  Future<Either<Failure, Recipe>> getRecipeById(String id);
  Future<Either<Failure, void>> createRecipe(Recipe recipe);
  Future<Either<Failure, void>> updateRecipe(Recipe recipe);
  Future<Either<Failure, void>> deleteRecipe(String id);
  Future<Either<Failure, void>> likeRecipe(String recipeId, String userId);
  Future<Either<Failure, void>> reportRecipe(
      String recipeId, String userId, String reason);
  Future<Either<Failure, void>> updateViews(String recipeId);
}

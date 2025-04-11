import 'package:dartz/dartz.dart';
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:recipez/features/recipes/data/models/recipe_model.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Recipe>> getAllRecipes(String userId) {
    return remoteDataSource.getAllRecipes(userId);
  }

  @override
  Stream<List<Recipe>> getFavoriteRecipes(List<String> favorites) {
    return remoteDataSource.getFavoriteRecipes(favorites);
  }

  @override
  Stream<List<Recipe>> getUserRecipes(List<String> myRecipes) {
    return remoteDataSource.getUserRecipes(myRecipes);
  }

  @override
  Stream<List<Recipe>> getRecipesByLikes(String userId, bool limit) {
    return remoteDataSource.getRecipesByLikes(userId, limit);
  }

  @override
  Stream<List<Recipe>> getRecipesByDate(String userId, bool limit) {
    return remoteDataSource.getRecipesByDate(userId, limit);
  }

  @override
  Stream<List<Recipe>> getRecipesByViews(String userId, bool limit) {
    return remoteDataSource.getRecipesByViews(userId, limit);
  }

  @override
  Stream<List<Recipe>> searchRecipes(String text, String userId) {
    return remoteDataSource.searchRecipes(text, userId);
  }

  @override
  Future<List<Recipe>> searchRecipesByIngredient(
      String name, int value, String dimension, String userId) {
    return remoteDataSource.searchRecipesByIngredient(
        name, value, dimension, userId);
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeById(String id) async {
    try {
      final recipe = await remoteDataSource.getRecipeById(id);
      if (recipe == null) {
        return Left(ServerFailure());
      }
      return Right(recipe);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createRecipe(Recipe recipe) async {
    try {
      await remoteDataSource.createRecipe(recipe as RecipeModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateRecipe(Recipe recipe) async {
    try {
      await remoteDataSource.updateRecipe(recipe as RecipeModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipe(String id) async {
    try {
      await remoteDataSource.deleteRecipe(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> likeRecipe(
      String recipeId, String userId) async {
    try {
      await remoteDataSource.likeRecipe(recipeId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> reportRecipe(
      String recipeId, String userId, String reason) async {
    try {
      await remoteDataSource.reportRecipe(recipeId, userId, reason);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateViews(String recipeId) async {
    try {
      await remoteDataSource.updateViews(recipeId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

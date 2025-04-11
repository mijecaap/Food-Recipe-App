import 'package:equatable/equatable.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class GetAllRecipesEvent extends RecipeEvent {
  final String userId;

  const GetAllRecipesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetFavoriteRecipesEvent extends RecipeEvent {
  final List<String> favorites;

  const GetFavoriteRecipesEvent(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class GetUserRecipesEvent extends RecipeEvent {
  final List<String> myRecipes;

  const GetUserRecipesEvent(this.myRecipes);

  @override
  List<Object?> get props => [myRecipes];
}

class GetRecipesByLikesEvent extends RecipeEvent {
  final String userId;
  final bool limit;

  const GetRecipesByLikesEvent(this.userId, this.limit);

  @override
  List<Object?> get props => [userId, limit];
}

class GetRecipesByDateEvent extends RecipeEvent {
  final String userId;
  final bool limit;

  const GetRecipesByDateEvent(this.userId, this.limit);

  @override
  List<Object?> get props => [userId, limit];
}

class GetRecipesByViewsEvent extends RecipeEvent {
  final String userId;
  final bool limit;

  const GetRecipesByViewsEvent(this.userId, this.limit);

  @override
  List<Object?> get props => [userId, limit];
}

class SearchRecipesEvent extends RecipeEvent {
  final String text;
  final String userId;

  const SearchRecipesEvent(this.text, this.userId);

  @override
  List<Object?> get props => [text, userId];
}

class SearchRecipesByIngredientEvent extends RecipeEvent {
  final String name;
  final int value;
  final String dimension;
  final String userId;

  const SearchRecipesByIngredientEvent({
    required this.name,
    required this.value,
    required this.dimension,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, value, dimension, userId];
}

class CreateRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const CreateRecipeEvent(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class UpdateRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const UpdateRecipeEvent(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class DeleteRecipeEvent extends RecipeEvent {
  final String id;

  const DeleteRecipeEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class LikeRecipeEvent extends RecipeEvent {
  final String recipeId;
  final String userId;

  const LikeRecipeEvent(this.recipeId, this.userId);

  @override
  List<Object?> get props => [recipeId, userId];
}

class ReportRecipeEvent extends RecipeEvent {
  final String recipeId;
  final String userId;
  final String reason;

  const ReportRecipeEvent({
    required this.recipeId,
    required this.userId,
    required this.reason,
  });

  @override
  List<Object?> get props => [recipeId, userId, reason];
}

class GetRecipeByIdEvent extends RecipeEvent {
  final String id;

  const GetRecipeByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateViewsEvent extends RecipeEvent {
  final String recipeId;

  const UpdateViewsEvent(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

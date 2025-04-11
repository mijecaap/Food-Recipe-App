import 'package:equatable/equatable.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecipesLoaded extends RecipeState {
  final List<Recipe> recipes;

  const RecipesLoaded(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class RecipeActionSuccess extends RecipeState {
  final String message;

  const RecipeActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SingleRecipeLoaded extends RecipeState {
  final Recipe recipe;

  const SingleRecipeLoaded(this.recipe);

  @override
  List<Object?> get props => [recipe];
}
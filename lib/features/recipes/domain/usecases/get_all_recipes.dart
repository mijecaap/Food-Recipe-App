import 'package:equatable/equatable.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/domain/repositories/recipe_repository.dart';

class GetAllRecipes {
  final RecipeRepository repository;

  GetAllRecipes(this.repository);

  Stream<List<Recipe>> call(GetAllRecipesParams params) {
    return repository.getAllRecipes(params.userId);
  }
}

class GetAllRecipesParams extends Equatable {
  final String userId;

  const GetAllRecipesParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
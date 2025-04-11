import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/core/usecases/usecase.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/domain/repositories/recipe_repository.dart';

class CreateRecipe implements UseCase<void, CreateRecipeParams> {
  final RecipeRepository repository;

  CreateRecipe(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateRecipeParams params) {
    return repository.createRecipe(params.recipe);
  }
}

class CreateRecipeParams extends Equatable {
  final Recipe recipe;

  const CreateRecipeParams({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}
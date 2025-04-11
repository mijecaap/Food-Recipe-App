import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/core/usecases/usecase.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/domain/repositories/recipe_repository.dart';

class GetRecipeById implements UseCase<Recipe, GetRecipeByIdParams> {
  final RecipeRepository repository;

  GetRecipeById(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(GetRecipeByIdParams params) {
    return repository.getRecipeById(params.id);
  }
}

class GetRecipeByIdParams extends Equatable {
  final String id;

  const GetRecipeByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
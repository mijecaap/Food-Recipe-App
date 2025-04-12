import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipez/core/services/cache_service.dart';
import 'package:recipez/features/recipes/data/models/recipe_model.dart';
import 'package:recipez/features/recipes/data/repositories/cloud_storage_repository.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;
  final _cloudStorageRepository = CloudStorageRepository();
  final CacheService _cacheService;
  StreamSubscription? _recipeSubscription;

  RecipeBloc({required this.repository, required CacheService cacheService})
    : _cacheService = cacheService,
      super(RecipeInitial()) {
    on<GetAllRecipesEvent>(_onGetAllRecipes);
    on<GetFavoriteRecipesEvent>(_onGetFavoriteRecipes);
    on<GetUserRecipesEvent>(_onGetUserRecipes);
    on<GetRecipesByLikesEvent>(_onGetRecipesByLikes);
    on<GetRecipesByDateEvent>(_onGetRecipesByDate);
    on<GetRecipesByViewsEvent>(_onGetRecipesByViews);
    on<SearchRecipesEvent>(_onSearchRecipes);
    on<SearchRecipesByIngredientEvent>(_onSearchRecipesByIngredient);
    on<CreateRecipeEvent>(_onCreateRecipe);
    on<UpdateRecipeEvent>(_onUpdateRecipe);
    on<DeleteRecipeEvent>(_onDeleteRecipe);
    on<LikeRecipeEvent>(_onLikeRecipe);
    on<ReportRecipeEvent>(_onReportRecipe);
    on<GetRecipeByIdEvent>(_onGetRecipeById);
    on<UpdateViewsEvent>(_onUpdateViews);
  }

  Future<String> uploadImage(File image) {
    return _cloudStorageRepository.uploadRecipeImage(image);
  }

  Future<void> createRecipe(RecipeModel recipe) async {
    add(CreateRecipeEvent(recipe));
  }

  Future<void> updateRecipe(RecipeModel recipe) async {
    add(UpdateRecipeEvent(recipe));
  }

  void _onGetAllRecipes(
    GetAllRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());

    // Intentar obtener recetas del caché
    final cachedRecipes = await _cacheService.getCachedRecipes();
    if (cachedRecipes != null) {
      emit(RecipesLoaded(cachedRecipes));
    }

    // Obtener recetas actualizadas de Firestore
    _recipeSubscription?.cancel();
    _recipeSubscription = repository.getAllRecipes(event.userId).listen((
      recipes,
    ) {
      // Actualizar el caché con las nuevas recetas
      _cacheService.cacheRecipes(recipes as List<RecipeModel>);
      emit(RecipesLoaded(recipes));
    }, onError: (error) => emit(RecipeError(error.toString())));
  }

  void _onGetFavoriteRecipes(
    GetFavoriteRecipesEvent event,
    Emitter<RecipeState> emit,
  ) {
    emit(RecipeLoading());
    _recipeSubscription?.cancel();
    _recipeSubscription = repository
        .getFavoriteRecipes(event.favorites)
        .listen(
          (recipes) => emit(RecipesLoaded(recipes)),
          onError: (error) => emit(RecipeError(error.toString())),
        );
  }

  void _onGetUserRecipes(GetUserRecipesEvent event, Emitter<RecipeState> emit) {
    emit(RecipeLoading());
    _recipeSubscription?.cancel();
    _recipeSubscription = repository
        .getUserRecipes(event.myRecipes)
        .listen(
          (recipes) => emit(RecipesLoaded(recipes)),
          onError: (error) => emit(RecipeError(error.toString())),
        );
  }

  void _onGetRecipesByLikes(
    GetRecipesByLikesEvent event,
    Emitter<RecipeState> emit,
  ) {
    emit(RecipeLoading());
    _recipeSubscription?.cancel();
    _recipeSubscription = repository
        .getRecipesByLikes(event.userId, event.limit)
        .listen(
          (recipes) => emit(RecipesLoaded(recipes)),
          onError: (error) => emit(RecipeError(error.toString())),
        );
  }

  Stream<List<Recipe>> readOrderLikesData(String userId, bool limit) {
    // Intentar obtener del caché primero
    _cacheService.getCachedPopularRecipes(userId).then((cachedRecipes) {
      if (cachedRecipes != null) {
        emit(RecipesLoaded(cachedRecipes));
      }
    });

    // Obtener datos actualizados
    return repository.getRecipesByLikes(userId, limit).map((recipes) {
      // Actualizar el caché con las nuevas recetas
      _cacheService.cachePopularRecipes(recipes as List<RecipeModel>, userId);
      return recipes;
    });
  }

  Stream<List<Recipe>> readOrderViewsData(String userId, bool limit) {
    return repository.getRecipesByViews(userId, limit);
  }

  Stream<List<Recipe>> readOrderDateData(String userId, bool limit) {
    // Intentar obtener del caché primero
    _cacheService.getCachedRecentRecipes(userId).then((cachedRecipes) {
      if (cachedRecipes != null) {
        emit(RecipesLoaded(cachedRecipes));
      }
    });

    // Obtener datos actualizados
    return repository.getRecipesByDate(userId, limit).map((recipes) {
      // Actualizar el caché con las nuevas recetas
      _cacheService.cacheRecentRecipes(recipes as List<RecipeModel>, userId);
      return recipes;
    });
  }

  void _onGetRecipesByDate(
    GetRecipesByDateEvent event,
    Emitter<RecipeState> emit,
  ) {
    emit(RecipeLoading());
    _recipeSubscription?.cancel();
    _recipeSubscription = repository
        .getRecipesByDate(event.userId, event.limit)
        .listen(
          (recipes) => emit(RecipesLoaded(recipes)),
          onError: (error) => emit(RecipeError(error.toString())),
        );
  }

  void _onGetRecipesByViews(
    GetRecipesByViewsEvent event,
    Emitter<RecipeState> emit,
  ) {
    emit(RecipeLoading());
    _recipeSubscription?.cancel();
    _recipeSubscription = repository
        .getRecipesByViews(event.userId, event.limit)
        .listen(
          (recipes) => emit(RecipesLoaded(recipes)),
          onError: (error) => emit(RecipeError(error.toString())),
        );
  }

  void _onSearchRecipes(
    SearchRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());

    // Intentar obtener resultados del caché primero
    final cachedResults = await _cacheService.getCachedSearchResults(
      event.text.toLowerCase(),
    );
    if (cachedResults != null) {
      emit(RecipesLoaded(cachedResults));
      return;
    }

    _recipeSubscription?.cancel();
    _recipeSubscription = repository
        .searchRecipes(event.text, event.userId)
        .listen((recipes) {
          // Guardar los resultados en caché
          _cacheService.cacheSearchResults(
            event.text.toLowerCase(),
            recipes as List<RecipeModel>,
          );
          emit(RecipesLoaded(recipes));
        }, onError: (error) => emit(RecipeError(error.toString())));
  }

  Future<void> _onSearchRecipesByIngredient(
    SearchRecipesByIngredientEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipes = await repository.searchRecipesByIngredient(
        event.name,
        event.value,
        event.dimension,
        event.userId,
      );
      emit(RecipesLoaded(recipes));
    } catch (error) {
      emit(RecipeError(error.toString()));
    }
  }

  Future<void> _onCreateRecipe(
    CreateRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    final result = await repository.createRecipe(event.recipe);
    result.fold(
      (failure) => emit(RecipeError(failure.toString())),
      (_) => emit(const RecipeActionSuccess('Receta creada exitosamente')),
    );
  }

  Future<void> _onUpdateRecipe(
    UpdateRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    final result = await repository.updateRecipe(event.recipe);
    result.fold(
      (failure) => emit(RecipeError(failure.toString())),
      (_) => emit(const RecipeActionSuccess('Receta actualizada exitosamente')),
    );
  }

  Future<void> _onDeleteRecipe(
    DeleteRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    final result = await repository.deleteRecipe(event.id);
    result.fold(
      (failure) => emit(RecipeError(failure.toString())),
      (_) => emit(const RecipeActionSuccess('Receta eliminada exitosamente')),
    );
  }

  Future<void> _onLikeRecipe(
    LikeRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await repository.likeRecipe(event.recipeId, event.userId);
    result.fold(
      (failure) => emit(RecipeError(failure.toString())),
      (_) => emit(const RecipeActionSuccess('Like actualizado exitosamente')),
    );
  }

  Future<void> _onReportRecipe(
    ReportRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await repository.reportRecipe(
      event.recipeId,
      event.userId,
      event.reason,
    );
    result.fold(
      (failure) => emit(RecipeError(failure.toString())),
      (_) => emit(const RecipeActionSuccess('Receta reportada exitosamente')),
    );
  }

  Future<void> _onGetRecipeById(
    GetRecipeByIdEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    final result = await repository.getRecipeById(event.id);
    result.fold(
      (failure) => emit(RecipeError(failure.toString())),
      (recipe) => emit(SingleRecipeLoaded(recipe)),
    );
  }

  Future<void> _onUpdateViews(
    UpdateViewsEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await repository.updateViews(event.recipeId);
    result.fold(
      (failure) => emit(RecipeError(failure.toString())),
      (_) => emit(const RecipeActionSuccess('Vistas actualizadas')),
    );
  }

  @override
  Future<void> close() {
    _recipeSubscription?.cancel();
    return super.close();
  }
}

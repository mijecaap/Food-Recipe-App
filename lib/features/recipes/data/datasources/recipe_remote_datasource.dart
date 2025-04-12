import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipez/features/recipes/data/models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Stream<List<RecipeModel>> getAllRecipes(String userId);
  Stream<List<RecipeModel>> getFavoriteRecipes(List<String> favorites);
  Stream<List<RecipeModel>> getUserRecipes(List<String> myRecipes);
  Stream<List<RecipeModel>> getRecipesByLikes(String userId, bool limit);
  Stream<List<RecipeModel>> getRecipesByDate(String userId, bool limit);
  Stream<List<RecipeModel>> getRecipesByViews(String userId, bool limit);
  Stream<List<RecipeModel>> searchRecipes(String text, String userId);
  Future<List<RecipeModel>> searchRecipesByIngredient(
    String name,
    int value,
    String dimension,
    String userId,
  );
  Future<RecipeModel?> getRecipeById(String id);
  Future<void> createRecipe(RecipeModel recipe);
  Future<void> updateRecipe(RecipeModel recipe);
  Future<void> deleteRecipe(String id);
  Future<void> likeRecipe(String recipeId, String userId);
  Future<void> reportRecipe(String recipeId, String userId, String reason);
  Future<void> updateViews(String recipeId);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String recipes = 'recipes';
  final int _batchSize = 10; // Limitar el tamaño de los resultados

  RecipeRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Stream<List<RecipeModel>> getAllRecipes(String userId) {
    return _firestore
        .collection(recipes)
        .where('userId', isNotEqualTo: userId)
        .limit(_batchSize)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        RecipeModel.fromJson({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  @override
  Stream<List<RecipeModel>> getFavoriteRecipes(List<String> favorites) {
    return _firestore
        .collection(recipes)
        .where(FieldPath.documentId, whereIn: favorites)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        RecipeModel.fromJson({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  @override
  Stream<List<RecipeModel>> getUserRecipes(List<String> myRecipes) {
    return _firestore
        .collection(recipes)
        .where(FieldPath.documentId, whereIn: myRecipes)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        RecipeModel.fromJson({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  @override
  Stream<List<RecipeModel>> getRecipesByLikes(String userId, bool limit) {
    var query = _firestore
        .collection(recipes)
        .where('userId', isNotEqualTo: userId)
        .orderBy('likes', descending: true);

    if (limit) query = query.limit(10);

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => RecipeModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
    );
  }

  @override
  Stream<List<RecipeModel>> getRecipesByDate(String userId, bool limit) {
    var query = _firestore
        .collection(recipes)
        .where('userId', isNotEqualTo: userId)
        .orderBy('date', descending: true);

    if (limit) query = query.limit(10);

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => RecipeModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
    );
  }

  @override
  Stream<List<RecipeModel>> getRecipesByViews(String userId, bool limit) {
    var query = _firestore
        .collection(recipes)
        .where('userId', isNotEqualTo: userId)
        .orderBy('views', descending: true);

    if (limit) query = query.limit(10);

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => RecipeModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
    );
  }

  @override
  Stream<List<RecipeModel>> searchRecipes(String text, String userId) {
    return _firestore
        .collection(recipes)
        .where('userId', isNotEqualTo: userId)
        .where('title', isGreaterThanOrEqualTo: text)
        .where('title', isLessThan: '${text}z')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        RecipeModel.fromJson({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  @override
  Future<List<RecipeModel>> searchRecipesByIngredient(
    String name,
    int value,
    String dimension,
    String userId,
  ) async {
    final snapshot =
        await _firestore
            .collection(recipes)
            .where('userId', isNotEqualTo: userId)
            .get();

    return snapshot.docs
        .map((doc) => RecipeModel.fromJson({...doc.data(), 'id': doc.id}))
        .where(
          (recipe) => recipe.ingredients.any(
            (ingredient) =>
                ingredient['name'] == name &&
                ingredient['value'] == value &&
                ingredient['dimension'] == dimension,
          ),
        )
        .toList();
  }

  @override
  Future<RecipeModel?> getRecipeById(String id) async {
    final doc = await _firestore.collection(recipes).doc(id).get();
    if (!doc.exists) return null;
    return RecipeModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<void> createRecipe(RecipeModel recipe) async {
    final batch = _firestore.batch();
    final recipeRef = _firestore.collection(recipes).doc();
    batch.set(recipeRef, recipe.toJson());
    await batch.commit();
  }

  @override
  Future<void> updateRecipe(RecipeModel recipe) async {
    final batch = _firestore.batch();
    final recipeRef = _firestore.collection(recipes).doc(recipe.id);
    batch.update(recipeRef, recipe.toJson());
    await batch.commit();
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await _firestore.collection(recipes).doc(id).delete();
  }

  @override
  Future<void> likeRecipe(String recipeId, String userId) async {
    final doc = await _firestore.collection(recipes).doc(recipeId).get();
    final recipe = RecipeModel.fromJson({...doc.data()!, 'id': doc.id});

    List<String> likes = List.from(recipe.likes);
    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    await _firestore.collection(recipes).doc(recipeId).update({'likes': likes});
  }

  @override
  Future<void> reportRecipe(
    String recipeId,
    String userId,
    String reason,
  ) async {
    final doc = await _firestore.collection(recipes).doc(recipeId).get();
    final recipe = RecipeModel.fromJson({...doc.data()!, 'id': doc.id});

    List<Map<String, dynamic>> reports = List.from(recipe.reports);
    reports.add({'userId': userId, 'reason': reason, 'date': Timestamp.now()});

    await _firestore.collection(recipes).doc(recipeId).update({
      'reports': reports,
    });
  }

  @override
  Future<void> updateViews(String recipeId) async {
    final doc = await _firestore.collection(recipes).doc(recipeId).get();
    final recipe = RecipeModel.fromJson({...doc.data()!, 'id': doc.id});

    int views = recipe.views + 1;

    await _firestore.collection(recipes).doc(recipeId).update({'views': views});
  }
}

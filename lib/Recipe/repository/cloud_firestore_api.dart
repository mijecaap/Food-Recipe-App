import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';

class CloudFirestoreAPI {

  final String RECIPES = 'recipes';
  final String USERS = 'users';

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<RecipeCardModel>> readAllData(String userId) {
    return _db
      .collection(RECIPES)
      .where('userId', isNotEqualTo: userId )
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<RecipeCardModel>> readOrderLikesData(String userId) {
    return _db
      .collection(RECIPES)
      .where('userId', isNotEqualTo: userId )
      .orderBy('likes', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }
  
  Stream<List<RecipeCardModel>> readFavoritesData(List<String> favoritesId) {
    return _db
      .collection(RECIPES)
      .where(FieldPath.documentId, whereIn: favoritesId.isEmpty ? ['null'] : favoritesId)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<RecipeCardModel>> readMyRecipesData(List<String> myRecipes) {
    return _db
        .collection(RECIPES)
        .where(FieldPath.documentId, whereIn: myRecipes.isEmpty ? ['null'] : myRecipes)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Future<RecipeModel> readDataById(String id) async {
    final ref = _db.collection(RECIPES).doc(id);
    final snapshot = await ref.get();
    if (snapshot.exists){
      return RecipeModel.fromJson(snapshot.data()!, id);
    }
    return RecipeModel(photoURL: '', title: '', description: '', personQuantity: '', estimatedTime: '', ingredients: [], steps: []);
  }

  Future<void> createData(RecipeModel recipe, String uid) async {
    CollectionReference ref = _db.collection(RECIPES);
    DocumentReference refUser = _db.collection(USERS).doc(uid);
    return ref.add({
      'photoURL': recipe.photoURL,
      'title': recipe.title,
      'userId': recipe.userId,
      'description': recipe.description,
      'personQuantity': recipe.personQuantity,
      'estimatedTime': recipe.estimatedTime,
      'ingredients': recipe.ingredients,
      'steps': recipe.steps,
      'dateCreation': recipe.dateCreation,
      'likesUserId': recipe.likesUserId,
      'likes': recipe.likes
    }).then((value) => refUser.update({
      'myRecipes': FieldValue.arrayUnion([value.id])
    }));
  }

  Future<void> updateData(RecipeModel recipe, String recipeID) async {
    DocumentReference ref = _db.collection(RECIPES).doc(recipeID);
    return ref.set({
      'photoURL': recipe.photoURL,
      'title': recipe.title,
      'description': recipe.description,
      'personQuantity': recipe.personQuantity,
      'estimatedTime': recipe.estimatedTime,
      'ingredients': recipe.ingredients,
      'steps': recipe.steps
    }, SetOptions(merge: true));
  }

  void updateLikeData(int likes, String id, String uid, bool isLiked) async {
    DocumentReference refRecipe = _db.collection(RECIPES).doc(id);
    DocumentReference refUser = _db.collection(USERS).doc(uid);
    if(isLiked) {
      return refRecipe.update({
        'likes': likes-1,
        'likesUserId': FieldValue.arrayRemove([uid])
      }).then((value) => refUser.update({
        'favoriteRecipes': FieldValue.arrayRemove([id])
      }));
    } else {
      return refRecipe.update({
      'likes': likes+1,
      'likesUserId': FieldValue.arrayUnion([uid])
      }).then((value) => refUser.update({
        'favoriteRecipes': FieldValue.arrayUnion([id])
      }));
    }
  }
  
  Stream<List<RecipeCardModel>> readSearchData(String text, String userId) {
    return _db
      .collection(RECIPES)
      .where('title', isGreaterThanOrEqualTo: text)
      .where('title', isLessThan: text + '~')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }
}
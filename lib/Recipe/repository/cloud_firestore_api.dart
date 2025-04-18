import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:recipez/Recipe/model/ingredient.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/ui/screens/recipe_form.dart';
import 'package:recipez/User/model/user.dart';

class Report {
  final String text;
  final String idUser;

  Report({required this.text, required this.idUser});
}

class CloudFirestoreAPI {

  final String RECIPES = 'recipes';
  final String USERS = 'users';
  final String INGREDIENTS = 'ingredients';

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<RecipeCardModel>> readAllData(String userId) {
    return _db
      .collection(RECIPES)
      .where('userId', isNotEqualTo: userId )
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<RecipeCardModel>> readOrderLikesData(String userId, bool limit) {
    return _db
      .collection(RECIPES)
      .where('likes', isGreaterThan: 0 )
      .orderBy('likes', descending: true)
      .limit(limit ? 4 : 10)
      .snapshots()
      .map((snapshot) => snapshot.docs.where((doc) => doc['userId'] != userId && doc['status'] == true).map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<RecipeCardModel>> readOrderDateData(String userId, bool limit) {
    return _db
        .collection(RECIPES)
        .where('dateCreation', isGreaterThan: DateTime(DateTime.now().year, DateTime.now().month))
        .orderBy('dateCreation', descending: true)
        .limit(limit ? 4 : 10)
        .snapshots()
        .map((snapshot) => snapshot.docs.where((doc) => doc['userId'] != userId && doc['status'] == true).map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<RecipeCardModel>> readOrderViewsData(String userId, bool limit) {
    return _db
        .collection(RECIPES)
        .where('views', isGreaterThan: 0 )
        .orderBy('views', descending: true)
        .limit(limit ? 4 : 10)
        .snapshots()
        .map((snapshot) => snapshot.docs.where((doc) => doc['userId'] != userId && doc['status'] == true).map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }
  
  Stream<List<RecipeCardModel>> readFavoritesData(List<String> favoritesId) {
    return _db
      .collection(RECIPES)
      .where(FieldPath.documentId, whereIn: favoritesId.isEmpty ? ['null'] : favoritesId)
      .snapshots()
        .map((snapshot) => snapshot.docs.where((doc) => doc['status'] == true).map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<RecipeCardModel>> readMyRecipesData(List<String> myRecipes) {
    return _db
        .collection(RECIPES)
        .where(FieldPath.documentId, whereIn: myRecipes.isEmpty ? ['null'] : myRecipes)
        .snapshots()
        .map((snapshot) => snapshot.docs.where((doc) => doc['status'] == true).map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Future<RecipeModel> readDataById(String id) async {
    final ref = _db.collection(RECIPES).doc(id);
    final snapshot = await ref.get();
    if (snapshot.exists){
      return RecipeModel.fromJson(snapshot.data()!, id);
    }
    return RecipeModel(photoURL: '', title: '', description: '', personQuantity: '', estimatedTime: '', type: '', ingredients: [], steps: []);
  }

  Future<UserModel> readUserById(String uid) async {
    final ref = _db.collection(USERS).doc(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
    return UserModel(uid: '', name: '', email: '', photoURL: '');
  }

  Future<List<DocumentSnapshot<Object?>>> readIngredientById(List<dynamic> listId) async {
    final collection = _db.collection(INGREDIENTS);
    final listDocuments = <DocumentSnapshot>[];

    for(int i = 0; i < listId.length; i++) {
      final documentSnapshot = await collection.doc(listId[i]).get();
      listDocuments.add(documentSnapshot);
    }

    return listDocuments;
  }

  Future<void> createData(RecipeModel recipe, String uid) async {
    CollectionReference ref = _db.collection(RECIPES);
    DocumentReference refUser = _db.collection(USERS).doc(uid);
    CollectionReference refIngredient = _db.collection(INGREDIENTS);
    late List<String> listIdRecipes = [];

    for(int i = 0; i < recipe.ingredients.length; i++) {
      final documentReference = await refIngredient.add({
        'name': recipe.ingredients[i]["name"],
        'value': recipe.ingredients[i]["value"],
        'valueText': recipe.ingredients[i]["valueText"],
        'dimension': recipe.ingredients[i]["dimension"]
      });
      listIdRecipes.add(documentReference.id);
    }

    final documentRecipeRef = await ref.add({
      'userId': recipe.userId,
      'photoURL': recipe.photoURL,
      'title': recipe.title,
      'description': recipe.description,
      'personQuantity': recipe.personQuantity,
      'estimatedTime': recipe.estimatedTime,
      'type': recipe.type,
      'ingredients': listIdRecipes,
      'steps': recipe.steps,
      'dateCreation': recipe.dateCreation,
      'likesUserId': recipe.likesUserId,
      'likes': recipe.likes,
      'views': recipe.views,
      'reports': recipe.reports,
      'status': recipe.status
    });

    for (int i = 0; i < listIdRecipes.length; i++) {
      final documentReference = refIngredient.doc(listIdRecipes[i]);
      await documentReference.set({
        'idRecipe': documentRecipeRef.id
      }, SetOptions(merge: true));
    }

    return refUser.update({
      'myRecipes': FieldValue.arrayUnion([documentRecipeRef.id])
    });
  }

  Future<void> updateData(RecipeModel recipe) async {
    DocumentReference ref = _db.collection(RECIPES).doc(recipe.id);

    print(recipe.id);
    //DocumentReference refUser = _db.collection(USERS).doc(uid);
    //CollectionReference refIngredient = _db.collection(INGREDIENTS);
    //late List<String> listIdRecipes = [];

    /*for(int i = 0; i < recipe.ingredients.length; i++) {
      final documentReference = await refIngredient.add({
        'name': recipe.ingredients[i]["name"],
        'value': recipe.ingredients[i]["value"],
        'valueText': recipe.ingredients[i]["valueText"],
        'dimension': recipe.ingredients[i]["dimension"]
      });
      listIdRecipes.add(documentReference.id);
    }*/

    return await ref.update({
      'userId': recipe.userId,
      'photoURL': recipe.photoURL,
      'title': recipe.title,
      'description': recipe.description,
      'personQuantity': recipe.personQuantity,
      'estimatedTime': recipe.estimatedTime,
      'type': recipe.type,
      //'ingredients': listIdRecipes,
      'steps': recipe.steps,
    });

    /*for (int i = 0; i < listIdRecipes.length; i++) {
      final documentReference = refIngredient.doc(listIdRecipes[i]);
      await documentReference.set({
        'idRecipe': documentRecipeRef.id
      }, SetOptions(merge: true));
    }*/

    /*return refUser.update({
      'myRecipes': FieldValue.arrayUnion([documentRecipeRef.id])
    });*/
  }

  Future<DocumentReference<Object?>> createIngredient(IngredientModel ingredient) async {
    CollectionReference ref = _db.collection(INGREDIENTS);
    return ref.add({
      'name': ingredient.name,
      'valueText': ingredient.valueText,
      'value': ingredient.value,
      'dimension': ingredient.dimension,
      'idRecipe': ""
    });
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

  void updateReportData(String id, String uid, String text) async {
    DocumentReference refRecipe = _db.collection(RECIPES).doc(id);
    return refRecipe.update({
      'reports': FieldValue.arrayUnion([{"text": text, "userId": uid}])
    });
  }
  
  Stream<List<RecipeCardModel>> readSearchData(String text, String userId) {
    return _db
      .collection(RECIPES)
      .where('title', isGreaterThanOrEqualTo: text.toLowerCase())
      .where('title', isLessThan: text.toLowerCase() + '\uf8ff')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => RecipeCardModel.fromJson(doc.data(), doc.id)).toList());
  }

  Future<List<RecipeCardModel>> readSearchIngredientsData(String name, int value, String dimension, String userId) async {

    CollectionReference collection = _db.collection(INGREDIENTS);
    CollectionReference recipeCollection = _db.collection(RECIPES);
    Query query = collection
        .where('name', isEqualTo: name)
        .where('dimension', isEqualTo: dimension)
        .where('value', isLessThanOrEqualTo: value);

    QuerySnapshot snapshot = await query.get();
    List<DocumentSnapshot> ingredientsDocuments = snapshot.docs;
    List<String> recipeIds = [];

    for (var ingredientDocument in ingredientsDocuments) {
      if(!recipeIds.contains(ingredientDocument.get("idRecipe"))){
        recipeIds.add(ingredientDocument.get("idRecipe"));
      }
    }

    List<RecipeCardModel> listRecipes = [];

    for (var id in recipeIds) {
      await recipeCollection.doc(id).get().then((value) => listRecipes.add(RecipeCardModel.fromObject(value, id)));
    }

    return listRecipes;

  }


  void updateViews(String id) async {
    DocumentReference refRecipe = _db.collection(RECIPES).doc(id);
    await refRecipe.update({
      'views': FieldValue.increment(1),
    });
  }
}
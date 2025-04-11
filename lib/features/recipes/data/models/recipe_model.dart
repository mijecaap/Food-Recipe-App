import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.userId,
    required super.userName,
    required super.userPhotoUrl,
    required super.imageUrl,
    required super.preparationTime,
    required super.portions,
    required super.difficulty,
    required super.steps,
    required super.ingredients,
    required super.likes,
    required super.views,
    required super.date,
    required super.reports,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      preparationTime: json['preparationTime'] ?? 0,
      portions: json['portions'] ?? 0,
      difficulty: json['difficulty'] ?? 0,
      steps: List<String>.from(json['steps'] ?? []),
      ingredients: json['ingredients'] ?? [],
      likes: List<String>.from(json['likes'] ?? []),
      views: json['views'] ?? 0,
      date: json['date'] ?? Timestamp.now(),
      reports: List<Map<String, dynamic>>.from(json['reports'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'imageUrl': imageUrl,
      'preparationTime': preparationTime,
      'portions': portions,
      'difficulty': difficulty,
      'steps': steps,
      'ingredients': ingredients,
      'likes': likes,
      'views': views,
      'date': date,
      'reports': reports,
    };
  }
}

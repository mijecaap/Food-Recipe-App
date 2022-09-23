import 'package:flutter/material.dart';
import 'package:recipez/User/model/user.dart';
import 'ingredient_dimension.dart';

class RecipeModel {
  String? id;
  final String photoURL;
  final String title;
  String? userId;
  final String description;
  final String personQuantity;
  final String estimatedTime;
  final List<dynamic> ingredients;
  final List<dynamic> steps;
  DateTime? dateCreation;
  List<dynamic>? likesUserId;
  int? likes;

  RecipeModel({
    this.id,
    required this.photoURL,
    required this.title,
    this.userId,
    required this.description,
    required this.personQuantity,
    required this.estimatedTime,
    required this.ingredients,
    required this.steps,
    this.dateCreation,
    this.likesUserId,
    this.likes
  });

  static RecipeModel fromJson(Map<String, dynamic> json, String id) {
    return RecipeModel(
      id: id,
      photoURL: json['photoURL'],
      title: json['title'],
      userId: json['userId'],
      description: json['description'],
      personQuantity: json['personQuantity'],
      estimatedTime: json['estimatedTime'],
      ingredients: json['ingredients'].toList(),
      steps: json['steps'].toList(),
      dateCreation: json['dateCreation'].toDate(),
      likesUserId: json['likesUserId'].toList(),
      likes: json['likes']
    );
  }
}
import 'package:flutter/material.dart';
import 'package:recipez/User/model/user.dart';
import 'ingredient_dimension.dart';

class RecipeModel {
  String? id;
  String? userId;
  final String photoURL;
  final String title;
  final String description;
  final String personQuantity;
  final String estimatedTime;
  final String type;
  final List<dynamic> ingredients;
  final List<dynamic> steps;
  DateTime? dateCreation;
  List<dynamic>? likesUserId;
  int? likes;
  int? views;
  List<dynamic>? reports;
  bool? status;

  RecipeModel({
    this.id,
    this.userId,
    required this.photoURL,
    required this.title,
    required this.description,
    required this.personQuantity,
    required this.estimatedTime,
    required this.type,
    required this.ingredients,
    required this.steps,
    this.dateCreation,
    this.likesUserId,
    this.likes,
    this.views,
    this.reports,
    this.status
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
      type: json['type'],
      ingredients: json['ingredients'].toList(),
      steps: json['steps'].toList(),
      dateCreation: json['dateCreation'].toDate(),
      likesUserId: json['likesUserId'].toList(),
      likes: json['likes'],
      views: json['views'],
      reports: json['reports'],
      status: json['status']
    );
  }
}
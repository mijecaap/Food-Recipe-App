import 'package:flutter/material.dart';
import 'package:recipez/User/model/user.dart';
import 'ingredient_dimension.dart';

class RecipeCardModel {
  String id;
  final String photoURL;
  final String title;
  List<dynamic> likesUserId;
  int likes;

  RecipeCardModel({
    required this.id,
    required this.photoURL,
    required this.title,
    required this.likesUserId,
    required this.likes
  });

  static RecipeCardModel fromJson(Map<String, dynamic> json, String id) {
    return RecipeCardModel(
        id: id,
        photoURL: json['photoURL'],
        title: json['title'],
        likesUserId: json['likesUserId'].toList(),
        likes: json['likes']
    );
  }
}
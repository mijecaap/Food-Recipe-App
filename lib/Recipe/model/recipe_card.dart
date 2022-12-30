import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipez/User/model/user.dart';
import 'ingredient_dimension.dart';

class RecipeCardModel {
  String id;
  final String photoURL;
  final String title;
  final String personQuantity;
  final String estimatedTime;

  RecipeCardModel({
    required this.id,
    required this.photoURL,
    required this.title,
    required this.personQuantity,
    required this.estimatedTime
  });

  static RecipeCardModel fromJson(Map<String, dynamic> json, String id) {
    return RecipeCardModel(
      id: id,
      photoURL: json['photoURL'],
      title: json['title'],
      personQuantity: json['personQuantity'],
      estimatedTime: json['estimatedTime']
    );
  }

  static RecipeCardModel fromObject(DocumentSnapshot<Object?> snapshot, String id) {
    return RecipeCardModel(
      id: id,
      photoURL: snapshot.get("photoURL"),
      title: snapshot.get("title"),
      personQuantity: snapshot.get("personQuantity"),
      estimatedTime: snapshot.get("estimatedTime")
    );
  }
}
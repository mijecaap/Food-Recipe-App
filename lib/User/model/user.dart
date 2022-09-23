import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final bool? subscription;
  final List<dynamic>? myRecipes;
  final List<dynamic>? favoriteRecipes;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
    this.subscription,
    this.myRecipes,
    this.favoriteRecipes
  });

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photoURL: json['photoURL'],
      subscription: json['subscription'],
      myRecipes: json['myRecipes'].toList(),
      favoriteRecipes: json['favoriteRecipes'].toList()
    );
  }
}
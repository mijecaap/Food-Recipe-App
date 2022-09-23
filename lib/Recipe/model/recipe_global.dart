import 'package:flutter/material.dart';

class RecipeGlobal {
  String id;
  final String name;
  final String urlImage;

  RecipeGlobal({
    this.id = '',
    required this.name,
    required this.urlImage
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'urlImage': urlImage
  };

  static RecipeGlobal fromJson(Map<String, dynamic> json, String id) {
    return RecipeGlobal(
        id: id,
        name: json['title'],
        urlImage: json['urlImage']
    );
  }
}
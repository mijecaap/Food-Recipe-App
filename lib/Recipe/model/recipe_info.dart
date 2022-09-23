import 'package:flutter/foundation.dart';

class RecipeInfo {
  String name;
  String description;
  String person;
  String estimated_time;
  List<dynamic> ingredients;
  List<dynamic> steps;
  String urlImage;

  RecipeInfo({
    required this.name,
    required this.description,
    required this.person,
    required this.estimated_time,
    required this.ingredients,
    required this.steps,
    required this.urlImage
  });

  /*Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'urlImage': urlImage
  };*/

  static RecipeInfo fromJson(Map<String, dynamic> json) {
    return RecipeInfo(
        name: json['title'],
        description: json['description'],
        person: json['person'],
        estimated_time: json['estimated_time'],
        ingredients: json['ingredients'].toList(),
        steps: json['steps'].toList(),
        urlImage: json['urlImage']
    );
  }
}

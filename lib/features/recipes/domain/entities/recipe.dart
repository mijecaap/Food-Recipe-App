import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String description;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final String imageUrl;
  final int preparationTime;
  final int portions;
  final int difficulty;
  final List<String> steps;
  final List<dynamic> ingredients;
  final List<String> likes;
  final int views;
  final Timestamp date;
  final List<Map<String, dynamic>> reports;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.imageUrl,
    required this.preparationTime,
    required this.portions,
    required this.difficulty,
    required this.steps,
    required this.ingredients,
    required this.likes,
    required this.views,
    required this.date,
    required this.reports,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    userId,
    userName,
    userPhotoUrl,
    imageUrl,
    preparationTime,
    portions,
    difficulty,
    steps,
    ingredients,
    likes,
    views,
    date,
    reports,
  ];
}
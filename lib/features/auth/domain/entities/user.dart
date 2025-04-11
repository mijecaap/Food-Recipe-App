import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final bool subscription;
  final List<String> myRecipes;
  final List<String> favoriteRecipes;

  const User({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
    this.subscription = false,
    this.myRecipes = const [],
    this.favoriteRecipes = const [],
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    photoURL,
    subscription,
    myRecipes,
    favoriteRecipes,
  ];
}
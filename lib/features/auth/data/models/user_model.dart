import 'package:recipez/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.photoURL,
    super.subscription,
    super.myRecipes,
    super.favoriteRecipes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoURL: json['photoURL'] ?? '',
      subscription: json['subscription'] ?? false,
      myRecipes: List<String>.from(json['myRecipes'] ?? []),
      favoriteRecipes: List<String>.from(json['favoriteRecipes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'subscription': subscription,
      'myRecipes': myRecipes,
      'favoriteRecipes': favoriteRecipes,
    };
  }
}

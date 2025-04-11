import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipez/features/recipes/data/models/recipe_card.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/presentation/widgets/grid_view_recipes.dart';
import 'package:recipez/features/recipes/presentation/widgets/card_recipe.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/core/presentation/widgets/title_page.dart';

class ListRecipe extends StatelessWidget {
  final String userId;
  final String titlePage;
  final Stream<List<RecipeCardModel>> streamFunction;

  const ListRecipe({
    required this.userId,
    required this.titlePage,
    required this.streamFunction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.morado_2_347,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  TitlePage(text: titlePage)
                ],
              ),
              Expanded(
                child: StreamBuilder<List<RecipeCardModel>>(
                  stream: streamFunction,
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      final recipes = snapshot.data;
                      if (recipes!.isEmpty) {
                        return const Center(
                          child: Text('No hay recetas disponibles'),
                        );
                      }

                      final recipeCards = recipes
                          .map((recipe) => CardRecipe(
                                recipe: Recipe(
                                  id: recipe.id,
                                  title: recipe.title,
                                  description: '',
                                  userId: userId,
                                  userName: '',
                                  userPhotoUrl: '',
                                  imageUrl: recipe.photoURL,
                                  preparationTime:
                                      int.parse(recipe.estimatedTime),
                                  portions: int.parse(recipe.personQuantity),
                                  difficulty: 1,
                                  steps: const [],
                                  ingredients: const [],
                                  likes: const [],
                                  views: 0,
                                  date: Timestamp.now(),
                                  reports: const [],
                                ),
                              ))
                          .toList();

                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          GridViewRecipes(cardsRecipes: recipeCards),
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

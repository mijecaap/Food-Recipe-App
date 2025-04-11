import 'package:flutter/material.dart';
import 'package:recipez/features/recipes/presentation/widgets/card_recipe.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';

class ListRecipes extends StatelessWidget {
  final List<Recipe> recipes;

  const ListRecipes({required this.recipes, super.key});

  @override
  Widget build(BuildContext context) {
    return recipes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/not-results.png",
                  width: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  "No hay resultados",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            children:
                recipes.map((recipe) => CardRecipe(recipe: recipe)).toList(),
          );
  }
}

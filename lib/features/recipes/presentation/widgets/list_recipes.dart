import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/features/recipes/presentation/widgets/card_recipe.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/core/constants/app_color.dart';

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
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                "No hay resultados",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.morado_3_53c,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "¡Sé el primero en crear una receta!",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
        : GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          padding: const EdgeInsets.all(16),
          childAspectRatio: 0.9,
          children:
              recipes.map((recipe) => CardRecipe(recipe: recipe)).toList(),
        );
  }
}

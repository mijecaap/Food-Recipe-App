import 'package:flutter/material.dart';
import 'package:recipez/features/recipes/presentation/widgets/card_recipe.dart';

class GridViewRecipes extends StatelessWidget {
  final List<CardRecipe> cardsRecipes;

  const GridViewRecipes({required this.cardsRecipes, super.key});

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    var screenWidth = size.width;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: screenHeight / 48,
      mainAxisSpacing: screenHeight / 48,
      childAspectRatio: (screenWidth / (screenHeight / 2)),
      padding: EdgeInsets.only(
        top: screenHeight / 48,
        bottom: screenHeight / 48,
      ),
      children: cardsRecipes,
    );
  }
}

class EmptyPage {
  final String title;
  final String subtitle;
  final String imageURL;

  EmptyPage(this.title, this.subtitle, this.imageURL);
}

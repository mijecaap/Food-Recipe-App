import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';

class GridViewRecipes extends StatelessWidget {
  List<CardRecipe> cardsRecipes;

  GridViewRecipes({required this.cardsRecipes, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    var screenWidth = size.width;
    //final double itemWidth = (size.width - 16 * 3) / 2;
    //const double itemHeight = 180.0;

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

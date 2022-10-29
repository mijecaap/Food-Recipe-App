import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes_edit.dart';
import 'package:recipez/Shared/model/app_color.dart';

import 'card_recipe_edit.dart';

class ListRecipesEdit extends StatelessWidget {
  final List<CardRecipeEdit> cardsRecipesEdit;
  final int type; // search = 0, favorite = 1, myRecipes = 2

  const ListRecipesEdit({
    required this.cardsRecipesEdit,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List<EmptyPage> listEmptyPage = <EmptyPage>[
      EmptyPage(
          "No Results",
          "No matches found, please search for another recipe.",
          "assets/not-results.png"
      ),
      EmptyPage(
          "No Favorites",
          "Browse new recipes, and add them as favorites.",
          "assets/favorites.png"
      ),
      EmptyPage(
          "No Recipes",
          "Start creating and sharing new recipes.",
          "assets/my-recipes.png"
      )
    ];

    return cardsRecipesEdit.isEmpty
        ? (Container(
      padding: EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(AppColor.lila_1_8ff, BlendMode.modulate),
            child: Image(
              image: AssetImage(listEmptyPage[type].imageURL),
              height: 200,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            child: Text(
              listEmptyPage[type].title,
              style: GoogleFonts.roboto(
                  color: AppColor.negro,
                  fontSize: 16,
                  fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 200,
            child: Text(
              listEmptyPage[type].subtitle,
              style: GoogleFonts.roboto(
                  color: AppColor.gris_5_d79,
                  fontSize: 14
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    ))
        : (ListView(
      physics: BouncingScrollPhysics(),
      children: [
        GridViewRecipesEdit(cardsRecipesEdit: cardsRecipesEdit),
      ],
    ));
  }
}

class EmptyPage {
  final String title;
  final String subtitle;
  final String imageURL;

  EmptyPage(this.title, this.subtitle, this.imageURL);
}

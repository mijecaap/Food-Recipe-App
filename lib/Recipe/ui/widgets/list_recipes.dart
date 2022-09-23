import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes.dart';
import 'package:recipez/Shared/model/app_color.dart';

class ListRecipes extends StatelessWidget {
  final List<CardRecipe> cardsRecipes;
  final int type; // search = 0, favorite = 1, myRecipes = 2

  const ListRecipes({
    required this.cardsRecipes,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    var screenWidth = size.width;

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

    return cardsRecipes.isEmpty
        ? (Container(
            padding: EdgeInsets.only(bottom: screenHeight / 9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth / 2,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(AppColor.filterColor, BlendMode.modulate),
                    child: Image(
                      image: AssetImage(listEmptyPage[type].imageURL),
                    ),
                  )
                ),
                SizedBox(height: screenHeight / 48),
                Container(
                  width: screenWidth / 2,
                  child: Text(
                    listEmptyPage[type].title,
                    style: GoogleFonts.openSans(
                      color: AppColor.thirdyColor,
                      fontSize: screenHeight / 32,
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                Container(
                  width: screenWidth / 2,
                  child: Text(
                    listEmptyPage[type].subtitle,
                    style: GoogleFonts.openSans(
                        color: AppColor.thirdyColor,
                        fontSize: screenHeight / 48
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
              GridViewRecipes(cardsRecipes: cardsRecipes),
              SizedBox(height: screenHeight / 12)
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

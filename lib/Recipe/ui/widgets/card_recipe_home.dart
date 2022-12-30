import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/ui/screens/recipe_information.dart';
import 'package:recipez/Shared/model/app_color.dart';

import '../../../User/bloc/bloc_user.dart';

class CardRecipeHome extends StatelessWidget {

  String id;
  String imageRecipe;
  String titleRecipe;
  String personQuantity;
  String estimatedTime;
  String uid;
  bool isMain;
  RecipeBloc recipeBloc;
  //

  CardRecipeHome(this.id, this.imageRecipe, this.titleRecipe, this.personQuantity, this.estimatedTime, this.uid, this.isMain, this.recipeBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = (size.height - (statusHeight)) / 4;

    /*var size = MediaQuery.of(context).size;
    var itemWidth = size.width / 2;
    var screenHeight = size.height / 4;*/

    return GestureDetector(
      onTap: () {
        recipeBloc.updateViews(id);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                bloc: RecipeBloc(),
                child: RecipeInformation(id, uid, false),
              );
            })
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        width: 240,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenHeight / 24)
        ),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image(
                image: NetworkImage(imageRecipe),
                fit: BoxFit.cover,
              ),
            ),
            Container(
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withAlpha(0),
                      Colors.black12,
                      Colors.black87
                    ],
                  ),
                ),
                padding: EdgeInsets.all(screenHeight / 24),
                child: Container(
                    child: AutoSizeText(
                      titleRecipe[0].toUpperCase() + titleRecipe.substring(1),
                      style: GoogleFonts.openSans(
                          color: AppColor.thirdyColor,
                          fontSize: screenHeight / 9,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                      presetFontSizes: [screenHeight / 9],
                      overflowReplacement: Marquee(
                        text: titleRecipe[0].toUpperCase() + titleRecipe.substring(1),
                        blankSpace: 80,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        style: GoogleFonts.openSans(
                            color: AppColor.thirdyColor,
                            fontSize: screenHeight / 9,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    )
                )
            ),
            isMain ? Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: AppColor.blanco.withOpacity(0.8),
                child: Row(
                  children: [
                    Icon(Icons.group, size: 16, color: AppColor.morado_1_57a),
                    const SizedBox(width: 8),
                    Text(
                      personQuantity,
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: AppColor.morado_1_57a
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.schedule, size: 16, color: AppColor.morado_1_57a),
                    const SizedBox(width: 8),
                    Text(
                      "${estimatedTime} min",
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: AppColor.morado_1_57a
                      ),
                    )
                  ],
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

}
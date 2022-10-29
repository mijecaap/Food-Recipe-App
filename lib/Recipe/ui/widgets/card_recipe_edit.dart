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
import '../screens/recipe_information_edit.dart';

class CardRecipeEdit extends StatelessWidget {

  String id;
  String imageRecipe;
  String titleRecipe;
  int likes;
  bool isLiked;
  String uid;
  bool isMain;
  RecipeBloc recipeBloc;
  //

  CardRecipeEdit(this.id, this.imageRecipe, this.titleRecipe, this.likes, this.isLiked, this.uid, this.isMain, this.recipeBloc, {Key? key}) : super(key: key);

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
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                bloc: RecipeBloc(),
                child: RecipeInformationEdit(id),
              );
            })
        );
      },
      child: Container(
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
                      titleRecipe,
                      style: GoogleFonts.openSans(
                          color: AppColor.thirdyColor,
                          fontSize: screenHeight / 9,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                      presetFontSizes: [screenHeight / 9],
                      overflowReplacement: Marquee(
                        text: titleRecipe,
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
            isMain ? Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(screenHeight / 24),
                child: GestureDetector(
                  onTap: () {
                    recipeBloc.updateLikeRecipe(likes, id, uid, isLiked);
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColor.thirdyColor,
                    radius: screenHeight / 10,
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                      size: screenHeight / 8,
                      color: AppColor.backgroundColor,
                    ),
                  ),
                )
            ) : Container(),
          ],
        ),
      ),
    );
  }

}
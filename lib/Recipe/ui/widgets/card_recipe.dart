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

class CardRecipe extends StatelessWidget {

  String id;
  String imageRecipe;
  String titleRecipe;
  bool isViewed;
  String uid;
  bool isMain;
  RecipeBloc recipeBloc;
  //

  CardRecipe(this.id, this.imageRecipe, this.titleRecipe, this.isViewed, this.uid, this.isMain, this.recipeBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GestureDetector(
      onTap: () {
        if(isViewed) recipeBloc.updateViews(id);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                bloc: RecipeBloc(),
                child: RecipeInformation(id, uid, isMain),
              );
            })
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
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
              padding: const EdgeInsets.all(10),
              child: AutoSizeText(
                titleRecipe[0].toUpperCase() + titleRecipe.substring(1),
                style: GoogleFonts.openSans(
                  color: AppColor.thirdyColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
                maxLines: 1,
                presetFontSizes: [20],
                overflowReplacement: Marquee(
                  text: titleRecipe[0].toUpperCase() + titleRecipe.substring(1),
                  blankSpace: 80,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  style: GoogleFonts.openSans(
                    color: AppColor.thirdyColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

}
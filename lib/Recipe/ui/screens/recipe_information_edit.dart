import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_info.dart';
import 'package:recipez/Recipe/ui/screens/recipe_form.dart';
import 'package:recipez/Recipe/ui/screens/recipe_form_edit.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/User/ui/widgets/profile_container.dart';

import '../../bloc/bloc_recipe.dart';

class RecipeInformationEdit extends StatelessWidget {

  late RecipeBloc recipeBloc;
  late UserBloc userBloc;
  String id;

  RecipeInformationEdit(this.id);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    userBloc = BlocProvider.of(context);

    recipeBloc = BlocProvider.of(context);

    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background-app.png"),
                  colorFilter: ColorFilter.mode(Color(0xff990000).withOpacity(0.8), BlendMode.modulate),
                  fit: BoxFit.cover
              )
          ),
        ),
        Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            /*floatingActionButton: FloatingActionButton(
            child: Icon(Icons.expand_less),
            onPressed: () {
              pickImage();
            },
          ),*/
            body: FutureBuilder<RecipeModel?>(
              future: recipeBloc.readRecipeById(id),
              builder: (context, snapshot) {
                if (snapshot.hasError){
                  return Text("Error");
                } else if(snapshot.hasData) {
                  final recipe = snapshot.data;
                  return recipe == null
                      ? Center(child: Text("No data"))
                      : ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Container(
                        height: (screenHeight / 2.5),
                        width: size.width,
                        child: Stack(
                          children: [
                            Container(
                                height: screenHeight / 2.5,
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(screenHeight / 96),
                                        bottomRight: Radius.circular(screenHeight / 96)
                                    )
                                ),
                                child: Image(image: NetworkImage(recipe.photoURL), fit: BoxFit.fill)
                            ),
                            SafeArea(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: AppColor.thirdyColor,
                                      size: screenHeight / 24,
                                    ),
                                  ),
                                  /*SizedBox(width: screenHeight / 48),*/
                                  /*FittedText(heightBox: screenHeight / 16, firstText: *//**//*"New ", boldText: "Recipes",)*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight / 96),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenHeight / 48,
                            right: screenHeight / 48
                        ),
                        child: Text(
                          recipe.title,
                          style: GoogleFonts.openSans(
                              fontSize: screenHeight / 24,
                              color: AppColor.thirdyColor,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 96),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenHeight / 48,
                            right: screenHeight / 48
                        ),
                        child: Text(
                          recipe.description,
                          style: GoogleFonts.openSans(
                            fontSize: screenHeight / 48,
                            color: AppColor.thirdyColor,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: screenHeight / 96),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenHeight / 48,
                            right: screenHeight / 48
                        ),
                        child: Text(
                          "Ingredients",
                          style: GoogleFonts.openSans(
                              fontSize: screenHeight / 24,
                              color: AppColor.secondaryColor,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenHeight / 48,
                            right: screenHeight / 48
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: recipe.ingredients.length,
                          itemBuilder: (_, index) => Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight / 96
                            ),
                            child: Text(
                              "- ${recipe.ingredients[index]}",
                              style: GoogleFonts.openSans(
                                  color: AppColor.thirdyColor,
                                  fontSize: screenHeight / 48
                              ),
                            ),
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ),
                      SizedBox(height: screenHeight / 96),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenHeight / 48,
                            right: screenHeight / 48
                        ),
                        child: Text(
                          "Steps",
                          style: GoogleFonts.openSans(
                              fontSize: screenHeight / 24,
                              color: AppColor.secondaryColor,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenHeight / 48,
                            right: screenHeight / 48
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: recipe.steps.length,
                          itemBuilder: (_, index) => Padding(
                              padding: EdgeInsets.only(
                                  top: screenHeight / 96
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColor.fourthyColor
                                        ),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: GoogleFonts.openSans(
                                              color: AppColor.primaryColor,
                                              fontSize: screenHeight / 36
                                          ),
                                        ),
                                      )
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      recipe.steps[index],
                                      style: GoogleFonts.openSans(
                                          color: AppColor.thirdyColor,
                                          fontSize: screenHeight / 48
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ),
                      SizedBox(height: screenHeight / 96),

                      //Se agrega boton de editar receta:

                      Container(
                        height: 54,
                        width: 200,
                        decoration: BoxDecoration(
                            color: AppColor.morado_3_53c,
                            borderRadius: const BorderRadius.all(Radius.circular(15))
                        ),
                        child: Material(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                userBloc.getUserId().then((value) {

                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return BlocProvider(
                                          bloc: RecipeBloc(),
                                          child: RecipeFormEdit(userId: value, recipeId: id ),
                                        );
                                      })
                                  );
                                });
                              },
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20
                                ),
                                child: Text(
                                    "Edit",
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                              )
                          ),
                        ),
                      )

                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
        ),

      ],
    );
  }

}
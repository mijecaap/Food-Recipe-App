import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/ui/screens/add_recipe_screen.dart';
import 'package:recipez/Recipe/ui/screens/recipe_form.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/fitted_text.dart';
import 'package:recipez/User/bloc/bloc_user.dart';

class AddRecipe extends StatelessWidget {

  late UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    var screenWidth = size.width;

    userBloc = BlocProvider.of(context);

    return SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: screenHeight / 48,
            right: screenHeight / 48,
            bottom: screenHeight / 48,
            left: screenHeight / 48
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedText(
                heightBox: screenHeight / 16,
                firstText: "Create ",
                boldText: "Recipes",
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: screenHeight / 24,
                    right: screenHeight / 24,
                    bottom: screenHeight / 8
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenWidth / 1.5,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(AppColor.filterColor, BlendMode.modulate),
                          child: const Image(
                            image: AssetImage("assets/create-recipe.png"),
                          ),
                        )
                      ),
                      SizedBox(height: screenHeight / 48),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.all(Radius.circular(screenHeight / 48)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(screenHeight / 48),
                              color: AppColor.secondaryColor
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                /*Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return RecipeForm();
                                  })
                                );*/
                                userBloc.getUserId().then((value) {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return BlocProvider(
                                          bloc: RecipeBloc(),
                                          child: RecipeForm(userId: value),
                                        );
                                      })
                                  );
                                });
                              },
                              borderRadius: BorderRadius.circular(screenHeight / 48),
                              child: Container(
                                width: screenWidth / 1.5,
                                height: screenHeight / 12,
                                padding: EdgeInsets.all(screenHeight / 96),
                                child: FittedBox(
                                  child: Text(
                                    "Start create",
                                    style: GoogleFonts.openSans(
                                        color: Colors.white
                                    )
                                  ),
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 48),
                      SizedBox(
                        width: screenWidth / 1.5,
                        child: Text(
                          "Create new recipes and share them with others",
                          style: GoogleFonts.openSans(
                            color: AppColor.thirdyColor,
                            fontSize: screenHeight / 48
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/ui/screens/add_recipe_screen.dart';
import 'package:recipez/Recipe/ui/screens/recipe_form.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';
import 'package:recipez/User/bloc/bloc_user.dart';

class AddRecipe extends StatelessWidget {

  late UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    userBloc = BlocProvider.of(context);

    return SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 40,
            right: 20,
            left: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TittlePage(text: "Create Recipes"),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(AppColor.lila_1_8ff, BlendMode.modulate),
                        child: const Image(
                          image: AssetImage("assets/create-recipe.png"),
                          height: 250,
                        ),
                      ),
                      const SizedBox(height: 30),
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
                                          child: RecipeForm(userId: value),
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
                                    "Start create",
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Create new recipes and share them with others",
                          style: GoogleFonts.roboto(
                            color: AppColor.morado_1_57a,
                            fontSize: 16
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
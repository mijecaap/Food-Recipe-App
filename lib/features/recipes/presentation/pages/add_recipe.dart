import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/features/recipes/presentation/pages/recipe_form.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/core/presentation/widgets/title_page.dart';

class AddRecipe extends StatelessWidget {
  final String userId;

  const AddRecipe({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitlePage(text: "Crear Receta"),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppColor.lila_1_8ff,
                          BlendMode.modulate,
                        ),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeForm(userId: userId),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                "Crear Receta",
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

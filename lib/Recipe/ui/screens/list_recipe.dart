import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';

class ListRecipe extends StatelessWidget {

  String userId;
  late RecipeBloc recipeBloc;
  String titlePage;
  Stream<List<RecipeCardModel>> streamFunction;

  ListRecipe({required this.userId, required this.titlePage, required this.streamFunction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    recipeBloc = BlocProvider.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40,
              right: 20,
              left: 20
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.morado_2_347,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  TittlePage(text: titlePage)
                ],
              ),
              Expanded(
                child: StreamBuilder<List<RecipeCardModel>>(
                  stream: streamFunction,
                  builder: (_, snapshot) {
                    if(snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      final recipe = snapshot.data;
                      var wdgt = recipe!.map((e) {
                        return CardRecipe(e.id, e.photoURL, e.title, true, userId, false, recipeBloc);
                      }).toList();
                      return ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          GridViewRecipes(cardsRecipes: wdgt),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

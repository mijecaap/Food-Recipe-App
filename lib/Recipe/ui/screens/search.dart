import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes.dart';
import 'package:recipez/Recipe/ui/widgets/list_recipes.dart';
import 'package:recipez/Recipe/ui/widgets/search_input.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/fitted_text.dart';
import 'package:recipez/Shared/ui/widgets/title_header.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:recipez/Recipe/ui/widgets/input_text.dart';

class Search extends StatelessWidget {

  String userId;
  final _controllerTitleRecipe = TextEditingController();
  late RecipeBloc recipeBloc;

  Search(this.userId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    recipeBloc = BlocProvider.of(context);

    return Scaffold(
      extendBody: true,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background-app.png"),
                colorFilter: ColorFilter.mode(Color(0xff990000).withOpacity(0.8), BlendMode.modulate),
                fit: BoxFit.cover
            )
        ),
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(screenHeight / 48),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        SizedBox(width: screenHeight / 48),
                        FittedText(heightBox: screenHeight / 16, firstText: "Search ", boldText: "Recipes",)
                      ],
                    ),
                    InputText(
                        hintText: "Search",
                        maxLines: 1,
                        maxLength: 15,
                        textInputType: TextInputType.text,
                        textEditingController: _controllerTitleRecipe
                    ),
                    _controllerTitleRecipe.text.isEmpty ?
                      Container() :
                      Expanded(
                        child: StreamBuilder<List<RecipeCardModel>> (
                        stream: recipeBloc.readSearch(_controllerTitleRecipe.text, userId),
                        builder: (_, snapshot) {
                          if(snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            final recipe = snapshot.data;
                            var wdgt = recipe!.map((e) {
                              final isLiked = e.likesUserId.contains(userId);
                              return CardRecipe(e.id, e.photoURL, e.title, e.likes, isLiked, userId, false, recipeBloc);
                            }).toList();
                            return ListRecipes(cardsRecipes: wdgt, type: 3);
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                      )
                  ],
                )
            )
        ),
      ),
    );
  }
}

/*
ListView(
          physics: BouncingScrollPhysics(),
          children: [
            TitleHeader('Search', 'Recipes', ''),
            StickyHeader(
                header: SearchInput('Search for a new recipe'),
                content: ListRecipes(cardsRecipes: cards, type: 0)
            )
          ],
        ),
*/
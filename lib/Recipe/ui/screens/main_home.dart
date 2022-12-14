import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/model/recipe_global.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes.dart';
import 'package:recipez/Shared/ui/widgets/button_search.dart';
import 'package:recipez/Shared/ui/widgets/fitted_text.dart';
import 'package:recipez/Shared/ui/widgets/subtitle_button.dart';

import '../../../User/bloc/bloc_user.dart';

class MainHome extends StatelessWidget {
  
  late UserBloc userBloc;

  MainHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    
    userBloc = BlocProvider.of(context);

    return SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: screenHeight / 48,
            right: screenHeight / 48,
            left: screenHeight / 48
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedText(
                heightBox: size.height / 16,
                firstText: "All ",
                boldText: "Recipes ",
                secondText: "for you",
              ),
              SizedBox(height: screenHeight / 48),
              ButtonSearch(
                heightBox: size.height / 16,
                userBloc: userBloc,
              ),
              SizedBox(height: screenHeight / 48),
              BlocProvider(
                bloc: RecipeBloc(),
                child: FutureBuilder(
                  future: userBloc.getUserId(),
                  builder: (_, snapshot) {
                    if(snapshot.hasError){
                      return Text("No se encontr?? su id");
                    } else if (snapshot.hasData) {
                      final userId = snapshot.data.toString();
                      return ContainerRecipes(userId: userId);
                    } else {
                      return Text("CARGANDO");
                    }
                  },
                ),
              )
            ],
          ),
        )
    );

  }
  
}

class ContainerRecipes extends StatelessWidget {

  late RecipeBloc recipeBloc;
  String userId;

  ContainerRecipes({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    recipeBloc = BlocProvider.of(context);

    return Flexible(
        child: StreamBuilder<List<RecipeCardModel>>(
          stream: recipeBloc.readAllRecipes(userId),
          builder: (context, snapshot){
            if (snapshot.hasError){
              return Text('Ocurri?? un error');
            } else if (snapshot.hasData) {
              final recipe = snapshot.data;
              var wdgt = recipe!.map((e) {
                final isLiked = e.likesUserId.contains(userId);
                return CardRecipe(e.id, e.photoURL, e.title, e.likes, isLiked, userId, true, recipeBloc);
              }).toList();
              return ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  const SubtitleButton(colorText: "Popular ", secondText: "recipes"),
                  GridViewRecipes(cardsRecipes: wdgt),
                  /*const SubtitleButton(colorText: "New ", secondText: "recipes"),
                    GridViewRecipes(cardsRecipes: cards),*/
                  SizedBox(height: screenHeight / 12)
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}

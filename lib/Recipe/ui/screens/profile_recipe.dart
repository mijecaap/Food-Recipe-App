import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/fitted_text.dart';
import 'package:recipez/Shared/ui/widgets/title_header.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/User/ui/widgets/profile_container.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../User/model/user.dart';
import '../widgets/list_recipes.dart';

class ProfileRecipe extends StatelessWidget {

  late UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    userBloc = BlocProvider.of(context);

    List<CardRecipe> cards = [];

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
                heightBox: screenHeight / 16,
                firstText: "My ",
                boldText: "Recipes",
              ),
              SizedBox(height: screenHeight / 48),
              ProfileContainer(heightBox: screenHeight / 12),
              SizedBox(height: screenHeight / 48),
              BlocProvider(
                bloc: RecipeBloc(),
                child: FutureBuilder(
                  future: userBloc.getUserId(),
                  builder: (_, snapshot) {
                    if(snapshot.hasError){
                      return Text("No se encontró su id");
                    } else if (snapshot.hasData) {
                      final userId = snapshot.data.toString();
                      return FutureBuilder<UserModel>(
                        future: userBloc.readUser(userId),
                        builder: (_, snapshot) {
                          if(snapshot.hasError){
                            return Text(snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            final user = snapshot.data;
                            return user == null ?
                                Text("No data") :
                                ListUserRecipes(user: user);
                          } else {
                            return Text("CARGANDO");
                          }
                        },
                      );
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

class ListUserRecipes extends StatelessWidget {

  UserModel user;
  late RecipeBloc recipeBloc;

  ListUserRecipes({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    recipeBloc = BlocProvider.of(context);

    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              height: screenHeight / 16,
              child: TabBar(
                  indicatorColor: AppColor.secondaryColor,
                  labelColor: AppColor.thirdyColor,
                  labelStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w500,
                    fontSize: (screenHeight / 16) / 3,
                  ),
                  tabs: [
                    Tab(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, size: (screenHeight / 16) / 3),
                            SizedBox(width: screenHeight / 96),
                            Text("Favorites")
                          ],
                        )
                    ),
                    Tab(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant_menu, size: (screenHeight / 16) / 3),
                            SizedBox(width: screenHeight / 96),
                            Text("My recipes")
                          ],
                        )
                    ),
                  ]
              ),
            ),
            Expanded(
              //Add this to give height
              child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    StreamBuilder<List<RecipeCardModel>>(
                      stream: recipeBloc.readFavoritesRecipes(user.favoriteRecipes!.map((e) => e.toString()).toList()),
                      builder: (_, snapshot) {
                        if(snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.hasData) {
                          final recipe = snapshot.data;
                          var wdgt = recipe!.map((e) {
                            final isLiked = e.likesUserId.contains(user.uid);
                            return CardRecipe(e.id, e.photoURL, e.title, e.likes, isLiked, user.uid, false, recipeBloc);
                          }).toList();
                          return ListRecipes(cardsRecipes: wdgt, type: 1);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    StreamBuilder<List<RecipeCardModel>>(
                      stream: recipeBloc.readMyRecipes(user.myRecipes!.map((e) => e.toString()).toList()),
                      builder: (_, snapshot) {
                        if(snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.hasData) {
                          final recipe = snapshot.data;
                          var wdgt = recipe!.map((e) {
                            final isLiked = e.likesUserId.contains(user.uid);
                            return CardRecipe(e.id, e.photoURL, e.title, e.likes, isLiked, user.uid, false, recipeBloc);
                          }).toList();
                          return ListRecipes(cardsRecipes: wdgt, type: 2);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ]
              ),
            ),
          ],
        ),
      )
    );
  }
}

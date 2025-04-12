import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/ui/screens/list_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe_home.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/button_search.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';
import 'package:recipez/Shared/ui/widgets/subtitle_button.dart';

import '../../../User/bloc/bloc_user.dart';

class MainHome extends StatelessWidget {

  late UserBloc userBloc;
  MainHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userBloc = BlocProvider.of(context);
    return SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
              top: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20
                ),
                child: TittlePage(text: "All recipes for you"),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    right: 20,
                    left: 20
                ),
                child: ButtonSearch(userBloc: userBloc),
              ),
              const SizedBox(height: 20),
              BlocProvider(
                bloc: RecipeBloc(),
                child: FutureBuilder(
                  future: userBloc.getUserId(),
                  builder: (_, snapshot) {
                    if(snapshot.hasError){
                      return const Text("No se encontró su id");
                    } else if (snapshot.hasData) {
                      final userId = snapshot.data.toString();
                      return ContainerRecipes(userId: userId);
                    } else {
                      return const Text("CARGANDO");
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

    recipeBloc = BlocProvider.of(context);

    return Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  right: 20,
                  left: 20
              ),
              child: SubtitleButton(text: "Most Popular"),
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<RecipeCardModel>>(
              stream: recipeBloc.readOrderLikesData(userId,true),
              builder: (context, snapshot){
                if (snapshot.hasError){
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final recipe = snapshot.data;
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: recipe!.length + 1,
                      itemBuilder: (_, index) {
                        if(recipe.length != index){
                          var e = recipe[index];
                          return CardRecipeHome(e.id, e.photoURL, e.title, e.personQuantity, e.estimatedTime, userId, true, recipeBloc);
                        } else {
                          return SizedBox(
                              width: 120,
                              child: Material(
                                color: AppColor.gris_1_8fa,
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            bloc: RecipeBloc(),
                                            child: ListRecipe(userId: userId, titlePage: "Most Popular", streamFunction: recipeBloc.readOrderLikesData(userId,false)),
                                          );
                                        })
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "View more",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.morado_3_53c,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          );
                        }
                      },
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(
                  right: 20,
                  left: 20
              ),
              child: SubtitleButton(text: "Most Viewed"),
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<RecipeCardModel>>(
              stream: recipeBloc.readOrderViewsData(userId,true),
              builder: (context, snapshot){
                if (snapshot.hasError){
                  return const Text('Ocurrió un error');
                } else if (snapshot.hasData) {
                  final recipe = snapshot.data;
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: recipe!.length + 1,
                      itemBuilder: (_, index) {
                        if(recipe.length != index){
                          var e = recipe[index];
                          return CardRecipeHome(e.id, e.photoURL, e.title, e.personQuantity, e.estimatedTime, userId, true, recipeBloc);
                        } else {
                          return SizedBox(
                              width: 120,
                              child: Material(
                                color: AppColor.gris_1_8fa,
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            bloc: RecipeBloc(),
                                            child: ListRecipe(userId: userId, titlePage: "Most Viewed", streamFunction: recipeBloc.readOrderViewsData(userId,false)),
                                          );
                                        })
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "View more",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.morado_3_53c,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          );
                        }
                      },
                      padding: const EdgeInsets.only(
                          left: 20,
                          right: 20
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(
                  right: 20,
                  left: 20
              ),
              child: SubtitleButton(text: "Most Recent"),
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<RecipeCardModel>>(
              stream: recipeBloc.readOrderDateData(userId,true),
              builder: (context, snapshot){
                if (snapshot.hasError){
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final recipe = snapshot.data;
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: recipe!.length + 1,
                      itemBuilder: (_, index) {
                        if(recipe.length != index){
                          var e = recipe[index];
                          return CardRecipeHome(e.id, e.photoURL, e.title, e.personQuantity, e.estimatedTime, userId, true, recipeBloc);
                        } else {
                          return SizedBox(
                              width: 120,
                              child: Material(
                                color: AppColor.gris_1_8fa,
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            bloc: RecipeBloc(),
                                            child: ListRecipe(userId: userId, titlePage: "Most Recent", streamFunction: recipeBloc.readOrderDateData(userId,false)),
                                          );
                                        })
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "View more",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.morado_3_53c,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          );
                        }
                      },
                      padding: const EdgeInsets.only(
                          left: 20,
                          right: 20
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 80),
          ],
        )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/features/recipes/presentation/widgets/card_recipe_home.dart';
import 'package:recipez/features/recipes/presentation/pages/list_recipe.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/core/presentation/widgets/button_search.dart';
import 'package:recipez/core/presentation/widgets/title_page.dart';
import 'package:recipez/core/presentation/widgets/subtitle_button.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipez/features/recipes/data/models/recipe_card.dart';
import 'package:recipez/core/injection/injection_container.dart' as di;

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: TitlePage(text: "All recipes for you"),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: ButtonSearch(userBloc: context.read<AuthBloc>()),
            ),
            const SizedBox(height: 20),
            BlocProvider(
              create:
                  (context) => RecipeBloc(
                    repository: context.read<RecipeRepository>(),
                    cacheService: di.sl(),
                  ),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return ContainerRecipes(userId: state.user.uid);
                  } else if (state is AuthError) {
                    return Text(state.message);
                  } else if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const Text("Inicia sesión para ver las recetas");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerRecipes extends StatelessWidget {
  final String userId;

  const ContainerRecipes({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    final recipeBloc = context.read<RecipeBloc>();

    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: SubtitleButton(text: "Most Popular"),
          ),
          const SizedBox(height: 20),
          StreamBuilder<List<Recipe>>(
            stream: recipeBloc.readOrderLikesData(userId, true),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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
                      if (recipe.length != index) {
                        var e = recipe[index];
                        return CardRecipeHome(
                          e.id,
                          e.imageUrl,
                          e.title,
                          e.portions.toString(),
                          e.preparationTime.toString(),
                          userId,
                          true,
                          recipeBloc,
                        );
                      } else {
                        return SizedBox(
                          width: 120,
                          child: Material(
                            color: AppColor.gris_1_8fa,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BlocProvider(
                                        create:
                                            (context) => RecipeBloc(
                                              repository:
                                                  context
                                                      .read<RecipeRepository>(),
                                              cacheService: di.sl(),
                                            ),
                                        child: ListRecipe(
                                          userId: userId,
                                          titlePage: "Most Popular",
                                          streamFunction: recipeBloc
                                              .readOrderLikesData(userId, false)
                                              .map(
                                                (recipes) =>
                                                    recipes
                                                        .map(
                                                          (recipe) =>
                                                              RecipeCardModel.fromRecipe(
                                                                recipe,
                                                              ),
                                                        )
                                                        .toList(),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                    padding: const EdgeInsets.only(left: 20, right: 20),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: SubtitleButton(text: "Most Viewed"),
          ),
          const SizedBox(height: 20),
          StreamBuilder<List<Recipe>>(
            stream: recipeBloc.readOrderViewsData(userId, true),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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
                      if (recipe.length != index) {
                        var e = recipe[index];
                        return CardRecipeHome(
                          e.id,
                          e.imageUrl,
                          e.title,
                          e.portions.toString(),
                          e.preparationTime.toString(),
                          userId,
                          true,
                          recipeBloc,
                        );
                      } else {
                        return SizedBox(
                          width: 120,
                          child: Material(
                            color: AppColor.gris_1_8fa,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BlocProvider(
                                        create:
                                            (context) => RecipeBloc(
                                              repository:
                                                  context
                                                      .read<RecipeRepository>(),
                                              cacheService: di.sl(),
                                            ),
                                        child: ListRecipe(
                                          userId: userId,
                                          titlePage: "Most Viewed",
                                          streamFunction: recipeBloc
                                              .readOrderViewsData(userId, false)
                                              .map(
                                                (recipes) =>
                                                    recipes
                                                        .map(
                                                          (recipe) =>
                                                              RecipeCardModel.fromRecipe(
                                                                recipe,
                                                              ),
                                                        )
                                                        .toList(),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                    padding: const EdgeInsets.only(left: 20, right: 20),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: SubtitleButton(text: "Most Recent"),
          ),
          const SizedBox(height: 20),
          StreamBuilder<List<Recipe>>(
            stream: recipeBloc.readOrderDateData(userId, true),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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
                      if (recipe.length != index) {
                        var e = recipe[index];
                        return CardRecipeHome(
                          e.id,
                          e.imageUrl,
                          e.title,
                          e.portions.toString(),
                          e.preparationTime.toString(),
                          userId,
                          true,
                          recipeBloc,
                        );
                      } else {
                        return SizedBox(
                          width: 120,
                          child: Material(
                            color: AppColor.gris_1_8fa,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BlocProvider(
                                        create:
                                            (context) => RecipeBloc(
                                              repository:
                                                  context
                                                      .read<RecipeRepository>(),
                                              cacheService: di.sl(),
                                            ),
                                        child: ListRecipe(
                                          userId: userId,
                                          titlePage: "Most Recent",
                                          streamFunction: recipeBloc
                                              .readOrderDateData(userId, false)
                                              .map(
                                                (recipes) =>
                                                    recipes
                                                        .map(
                                                          (recipe) =>
                                                              RecipeCardModel.fromRecipe(
                                                                recipe,
                                                              ),
                                                        )
                                                        .toList(),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                    padding: const EdgeInsets.only(left: 20, right: 20),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

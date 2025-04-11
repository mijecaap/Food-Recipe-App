import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';
import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_state.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/core/presentation/widgets/title_page.dart';
import 'package:recipez/features/auth/presentation/widgets/profile_container.dart';
import '../widgets/list_recipes.dart';

class ProfileRecipe extends StatelessWidget {
  const ProfileRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitlePage(text: "My Recipe"),
          const SizedBox(height: 30),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return ProfileContainer(
                  userBloc: context.read<AuthBloc>(),
                  user: state.user,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 30),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return BlocProvider(
                  create: (_) => context.read<RecipeBloc>()
                    ..add(GetUserRecipesEvent(authState.user.myRecipes)),
                  child: BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, state) {
                      if (state is RecipeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RecipesLoaded) {
                        return ListUserRecipes(recipes: state.recipes);
                      } else if (state is RecipeError) {
                        return Center(child: Text(state.message));
                      }
                      return const Center(
                          child: Text("No hay recetas disponibles"));
                    },
                  ),
                );
              }
              return const Center(
                  child: Text("Inicia sesión para ver tus recetas"));
            },
          )
        ],
      ),
    ));
  }
}

class ListUserRecipes extends StatelessWidget {
  final List<Recipe> recipes;

  const ListUserRecipes({required this.recipes, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 54,
              child: TabBar(
                indicatorColor: AppColor.lila_1_8ff,
                tabs: [
                  Tab(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fact_check_outlined,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Mis recetas",
                          style: GoogleFonts.roboto(
                              color: Colors.black, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Favoritos",
                          style: GoogleFonts.roboto(
                              color: Colors.black, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListRecipes(recipes: recipes),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is Authenticated) {
                        return BlocProvider(
                          create: (_) => context.read<RecipeBloc>()
                            ..add(GetFavoriteRecipesEvent(
                                authState.user.favoriteRecipes)),
                          child: BlocBuilder<RecipeBloc, RecipeState>(
                            builder: (context, state) {
                              if (state is RecipeLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is RecipesLoaded) {
                                return ListRecipes(recipes: state.recipes);
                              } else if (state is RecipeError) {
                                return Center(child: Text(state.message));
                              }
                              return const Center(
                                  child: Text("No hay recetas favoritas"));
                            },
                          ),
                        );
                      }
                      return const Center(
                          child: Text("Inicia sesión para ver tus favoritos"));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

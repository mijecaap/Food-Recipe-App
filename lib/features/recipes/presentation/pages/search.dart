import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_state.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:recipez/features/recipes/presentation/widgets/input_text.dart';
import 'package:recipez/features/recipes/presentation/widgets/drop_down_menu.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/core/presentation/widgets/title_page.dart';
import 'package:recipez/features/recipes/presentation/widgets/list_recipes.dart';

class Search extends StatelessWidget {
  final String userId;
  late final RecipeBloc recipeBloc;

  Search(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    recipeBloc = BlocProvider.of<RecipeBloc>(context);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColor.blanco,
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColor.morado_2_347,
                    size: 30,
                  ),
                );
              },
            ),
            backgroundColor: AppColor.blanco,
            foregroundColor: AppColor.morado_3_53c,
            bottom: TabBar(
              indicatorColor: AppColor.lila_1_8ff,
              labelColor: AppColor.morado_3_53c,
              unselectedLabelColor: AppColor.lila_2_6be,
              tabs: [Tab(text: "Dish"), Tab(text: "Ingredient")],
            ),
            title: const TitlePage(text: "Search"),
          ),
          body: TabBarView(
            children: [
              SearchResult(type: 1, userId: userId, recipeBloc: recipeBloc),
              SearchResult(type: 2, userId: userId, recipeBloc: recipeBloc),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResult extends StatefulWidget {
  final int type;
  final String userId;
  final RecipeBloc recipeBloc;

  const SearchResult({
    required this.type,
    required this.userId,
    required this.recipeBloc,
    super.key,
  });

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late String dropdownValue = "kg";
  final _controllerTextRecipe = TextEditingController();
  final _controllerValueRecipe = TextEditingController();

  void pickValue(value) {
    setState(() {
      dropdownValue = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      child: Column(
        children: [
          widget.type == 1
              ? InputText(
                hintText: widget.type == 1 ? "Ex. Ceviche" : "user13181",
                maxLines: 1,
                maxLength: 20,
                textInputType: TextInputType.text,
                textEditingController: _controllerTextRecipe,
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: TextField(
                      style: GoogleFonts.openSans(
                        color: AppColor.lila_2_6be,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lila_2_6be),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lila_2_6be),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9.0),
                          ),
                        ),
                        hintText: 'Cant.',
                      ),
                      controller: _controllerValueRecipe,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DropdownButtonQuantity(
                      dropdownValue: dropdownValue,
                      pickValue: pickValue,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      style: GoogleFonts.openSans(
                        color: AppColor.lila_2_6be,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lila_2_6be),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lila_2_6be),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9.0),
                          ),
                        ),
                        hintText: 'Ingrediente',
                      ),
                      controller: _controllerTextRecipe,
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (widget.type == 1) {
                widget.recipeBloc.add(
                  SearchRecipesEvent(_controllerTextRecipe.text, widget.userId),
                );
              } else {
                widget.recipeBloc.add(
                  SearchRecipesByIngredientEvent(
                    name: _controllerTextRecipe.text,
                    value: int.tryParse(_controllerValueRecipe.text) ?? 0,
                    dimension: dropdownValue,
                    userId: widget.userId,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.morado_3_53c,
            ),
            child: const Text("Search", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          _controllerTextRecipe.text.isEmpty
              ? Container()
              : Expanded(
                child:
                    widget.type == 1
                        ? BlocBuilder<RecipeBloc, RecipeState>(
                          bloc: widget.recipeBloc,
                          builder: (context, state) {
                            if (state is RecipeLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is RecipesLoaded) {
                              final recipes = state.recipes;
                              return recipes.isEmpty
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/not-results.png",
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "No se encontraron resultados",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.morado_3_53c,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Intenta con otros términos de búsqueda",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListRecipes(recipes: recipes);
                            } else if (state is RecipeError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox.shrink();
                          },
                        )
                        : BlocBuilder<RecipeBloc, RecipeState>(
                          bloc: widget.recipeBloc,
                          builder: (context, state) {
                            if (state is RecipeLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is RecipesLoaded) {
                              final recipes = state.recipes;
                              return recipes.isEmpty
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/not-results.png",
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "No se encontraron resultados",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.morado_3_53c,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Intenta con otros términos de búsqueda",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListRecipes(recipes: recipes);
                            } else if (state is RecipeError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
              ),
        ],
      ),
    );
  }
}

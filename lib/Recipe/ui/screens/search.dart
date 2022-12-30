import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe_card.dart';
import 'package:recipez/Recipe/ui/screens/main_home.dart';
import 'package:recipez/Recipe/ui/widgets/card_recipe.dart';
import 'package:recipez/Recipe/ui/widgets/dropDown_Menu.dart';
import 'package:recipez/Recipe/ui/widgets/grid_view_recipes.dart';
import 'package:recipez/Recipe/ui/widgets/list_recipes.dart';
import 'package:recipez/Recipe/ui/widgets/search_input.dart';
import 'package:recipez/Shared/model/app_color.dart';

//import 'package:recipez/Shared/ui/widgets/fitted_text.dart';
import 'package:recipez/Shared/ui/widgets/title_header.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:recipez/Recipe/ui/widgets/input_text.dart';
import 'package:recipez/Recipe/ui/widgets/dropDown_Menu.dart';

class Search extends StatelessWidget {
  String userId;
  late RecipeBloc recipeBloc;

  Search(this.userId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    recipeBloc = BlocProvider.of(context);

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
                tabs: [
                  Tab(text: "Dish"),
                  Tab(text: "Ingredient"),
                ],
              ),
              title: TittlePage(text: "Search"),
            ),
            body: TabBarView(
              children: [
                SearchResult(type: 1, userId: userId, recipeBloc: recipeBloc),
                SearchResult(type: 2, userId: userId, recipeBloc: recipeBloc),
              ],
            ),
          )),
    );
  }
}

class SearchResult extends StatefulWidget {
  final int type;
  final String userId;
  final RecipeBloc recipeBloc;

  const SearchResult({required this.type, required this.userId, required this.recipeBloc, Key? key}) : super(key: key);

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
        padding: const EdgeInsets.symmetric(
            vertical: 30, horizontal: 15
        ),
        child: Column(
          children: [
            widget.type == 1 ?
            InputText(
                hintText: widget.type == 1 ? "Ex. Ceviche" : "user13181",
                maxLines: 1,
                maxLength: 20,
                textInputType: TextInputType.text,
                textEditingController: _controllerTextRecipe
            ) :
            Row(
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
                          borderSide: BorderSide(
                            color: AppColor.lila_2_6be
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9.0)
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.lila_2_6be
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(9.0)
                          )
                        ),
                        hintText: 'Cant.',
                      ),
                      controller: _controllerValueRecipe,
                    )
                  ),
                  Flexible(flex: 1, child: DropdownButtonQuantity(dropdownValue: dropdownValue, pickValue: pickValue)),
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
                          borderSide: BorderSide(
                            color: AppColor.lila_2_6be),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9.0)
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.lila_2_6be),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9.0)
                          )
                        ),
                        hintText: 'Ingrediente',
                      ),
                      controller: _controllerTextRecipe,
                    )
                  )
                ]),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text("Search")
            ),
            const SizedBox(height: 20),
            _controllerTextRecipe.text.isEmpty ?
            Container() :
            Expanded(
              child: widget.type == 1 ?
              StreamBuilder<List<RecipeCardModel>> (
                  stream: widget.recipeBloc.readSearch(_controllerTextRecipe.text, widget.userId),
                  builder: (_, snapshot) {
                    if(snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      print(snapshot.data);
                      final recipe = snapshot.data;
                      var wdgt = recipe!.map((e) {
                        return CardRecipe(e.id, e.photoURL, e.title, false, widget.userId, false, widget.recipeBloc);
                      }).toList();
                      return wdgt.isEmpty ? Text("No data") : ListRecipes(cardsRecipes: wdgt, type: 3);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }) :
              FutureBuilder<List<RecipeCardModel>> (
                  future: widget.recipeBloc.readSearchIngredients(_controllerTextRecipe.text, int.parse(_controllerValueRecipe.text), dropdownValue, widget.userId),
                  builder: (_, snapshot) {
                    if(snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      final recipe = snapshot.data;
                      var wdgt = recipe!.map((e) {
                        return CardRecipe(e.id, e.photoURL, e.title, false, widget.userId, false, widget.recipeBloc);
                      }).toList();
                      return wdgt.isEmpty ? Text("No data") : ListRecipes(cardsRecipes: wdgt, type: 3);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            )
          ],
        )
    );
  }
}

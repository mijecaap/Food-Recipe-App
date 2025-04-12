import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/model/recipe_info.dart';
import 'package:recipez/Recipe/ui/screens/recipe_form.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/User/model/user.dart';
import 'package:recipez/User/ui/widgets/profile_container.dart';

import '../../bloc/bloc_recipe.dart';

const List<Widget> textReport = <Widget>[
  Padding(padding: EdgeInsets.only(left: 16, right: 16), child: Text("Receta inapropiada")),
  Padding(padding: EdgeInsets.only(left: 16, right: 16), child: Text("Spam")),
  Padding(padding: EdgeInsets.only(left: 16, right: 16), child: Text("Receta peligrosa"))
];

enum Menu { edit, report }

class RecipeInformation extends StatefulWidget {

  String id;
  String userId;
  bool edit;


  RecipeInformation(this.id, this.userId, this.edit, {Key? key}) : super(key: key);

  @override
  State<RecipeInformation> createState() => _RecipeInformationState();
}

class _RecipeInformationState extends State<RecipeInformation> {
  final List<bool> _selectReport = <bool>[true, false, false];
  late List<dynamic> listIngr = [];

  late RecipeBloc recipeBloc;
  late UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    recipeBloc = BlocProvider.of(context);
    userBloc = BlocProvider.of(context);

    return Scaffold(
        extendBody: true,
        backgroundColor: AppColor.blanco,
        body: SafeArea(
          child: FutureBuilder<RecipeModel>(
            future: recipeBloc.readRecipeById(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error');
              } else if (snapshot.hasData) {
                final recipe = snapshot.data;
                final isLiked = recipe?.likesUserId?.contains(widget.userId);
                return recipe == null ? Center(child: Text("No data")) :
                Container(
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
                                setState((){});
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColor.morado_2_347,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 20),
                            TittlePage(text: recipe.title[0].toUpperCase() + recipe.title.substring(1)),
                            const Spacer(),
                            PopupMenuButton(
                              onSelected: (Menu item) {
                                  switch(item.name){
                                    case "edit":
                                      if (DateTime.now().difference(recipe.dateCreation!).inDays > 1) {
                                        ArtSweetAlert.show(
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                              type: ArtSweetAlertType.info,
                                              title: "To update your recipes, you have a maximum of one day after the recipe is published.",
                                            )
                                        );
                                      } else {
                                        userBloc.getUserId().then((value) {
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return BlocProvider(
                                                  bloc: RecipeBloc(),
                                                  child: RecipeForm(
                                                    id: widget.id,
                                                    userId: value,
                                                    photoURL: recipe.photoURL,
                                                    title: recipe.title,
                                                    description: recipe.description,
                                                    person: recipe.personQuantity,
                                                    estimatedTime: recipe.estimatedTime,
                                                    typeFood: recipe.type,
                                                    ingredients: listIngr,
                                                    steps: recipe.steps,
                                                  ),
                                                );
                                              })
                                          );
                                        });
                                      }
                                      break;
                                    case "report":
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: Text("Report recipe"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                ToggleWidget(selectReport: _selectReport),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                String selectReport = "";
                                                switch(_selectReport.indexWhere((element) => element == true)) {
                                                  case 0:
                                                    selectReport = "Receta Inapropiada";
                                                    break;
                                                  case 1:
                                                    selectReport = "Spam";
                                                    break;
                                                  case 2:
                                                    selectReport = "Receta Peligrosa";
                                                    break;
                                                }
                                                recipeBloc.updateReportRecipe(widget.id, widget.userId, selectReport);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Confirm")
                                            )
                                          ],
                                        )
                                      );
                                      break;
                                    default:
                                      break;
                                  }
                              },
                              itemBuilder: (context) => widget.edit ?
                              [
                                const PopupMenuItem(
                                  value: Menu.edit,
                                  child: Text("Edit"),
                                ),
                              ] :
                              [
                                const PopupMenuItem(
                                  value: Menu.report,
                                  child: Text("Report"),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              FutureBuilder<UserModel?>(
                                future: recipeBloc.readUserById(recipe.userId!),
                                builder: (_, snapshot) {
                                  if (!snapshot.hasData || snapshot.hasError) {
                                    return const CardLoading(
                                      height: 54,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    );
                                  } else {
                                    final user = snapshot.data;
                                    return Container(
                                      height: 54,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: AppColor.gris_3_de3,
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 10
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 32,
                                            width: 32,
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundImage: NetworkImage(user!.photoURL),
                                              onBackgroundImageError: (Object exception, StackTrace? stackTrace) {
                                                return;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                              child: Text(
                                                user.name,
                                                style: GoogleFonts.roboto(
                                                    color: AppColor.negro,
                                                    fontSize: 16
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                children: [
                                  Container(
                                    height: 256,
                                    width: double.infinity,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Image.network(recipe.photoURL, fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    left: 60,
                                    right: 60,
                                    bottom: 16,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColor.blanco.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.group, size: 24, color: AppColor.morado_1_57a),
                                          const SizedBox(width: 10),
                                          Text(
                                            recipe.personQuantity,
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                color: AppColor.morado_1_57a
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Icon(Icons.schedule, size: 24, color: AppColor.morado_1_57a),
                                          const SizedBox(width: 10),
                                          Text(
                                            "${recipe.estimatedTime} min",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                color: AppColor.morado_1_57a
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.visibility, size: 30, color: AppColor.morado_3_53c),
                                      const SizedBox(height: 8),
                                      Text(
                                        recipe.views! < 1000 ? recipe.views.toString() : (recipe.views! < 1000000 ? "${(recipe.views! / 1000).toString()} K" : "${(recipe.views! / 1000000).toString()} M"),
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: AppColor.morado_3_53c
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            recipeBloc.updateLikeRecipe(recipe.likes!, widget.id, widget.userId, isLiked!);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            isLiked! ? Icons.favorite : Icons.favorite_outline,
                                            size: 30,
                                            color: AppColor.rojo_f59,
                                          )
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        recipe.likes! < 1000 ? recipe.likes.toString() : (recipe.likes! < 1000000 ? "${(recipe.likes! / 1000).toString()} K" : "${(recipe.likes! / 1000000).toString()} M"),
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: AppColor.morado_3_53c
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Description:",
                                style: GoogleFonts.openSans(
                                    fontSize: 24,
                                    color: AppColor.morado_1_57a,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                recipe.description[0].toUpperCase() + recipe.description.substring(1),
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: AppColor.gris_5_d79,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Ingredients:",
                                style: GoogleFonts.openSans(
                                    fontSize: 24,
                                    color: AppColor.morado_1_57a,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              const SizedBox(height: 20),
                              FutureBuilder<List<DocumentSnapshot<Object?>>?>(
                                future: recipeBloc.readIngredientById(recipe.ingredients),
                                builder: (_, snapshot) {
                                  if (!snapshot.hasData || snapshot.hasError) {
                                    return const CardLoading(
                                      height: 54,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    );
                                  } else {
                                    final data = snapshot.data;
                                    data?.forEach((element) {
                                      //print(element.data());
                                      if(!listIngr.contains(element.data())) listIngr.add(element.data());
                                    });
                                    //listIngr = [];
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: data?.length,
                                      itemBuilder: (_, index) => Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8
                                        ),
                                        child: Text(
                                          "- ${data?[index]['valueText']} ${data?[index]['dimension']} ${data?[index]['name']}",
                                          style: GoogleFonts.openSans(
                                              color: AppColor.gris_5_d79,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Steps:",
                                style: GoogleFonts.openSans(
                                    fontSize: 24,
                                    color: AppColor.morado_1_57a,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: recipe.steps.length,
                                itemBuilder: (_, index) => Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColor.morado_1_57a
                                              ),
                                              child: Text(
                                                (index + 1).toString(),
                                                style: GoogleFonts.openSans(
                                                    color: AppColor.blanco,
                                                    fontSize: 24
                                                ),
                                              ),
                                            )
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            recipe.steps[index].split('. ').map((phrase) => phrase[0].toUpperCase() + phrase.substring(1)).join('. '),
                                            style: GoogleFonts.openSans(
                                                color: AppColor.gris_5_d79,
                                                fontSize: 16
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        )
                      ],
                    )
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
    );
  }
}

class ToggleWidget extends StatefulWidget {
  List<bool> selectReport;

  ToggleWidget({required this.selectReport, Key? key}) : super(key: key);

  @override
  State<ToggleWidget> createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.vertical,
      onPressed: (int index) {
        setState(() {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < widget.selectReport.length; i++) {
            widget.selectReport[i] = i == index;
          }
        });
      },
      borderRadius: BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: AppColor.morado_3_53c,
      selectedColor: AppColor.morado_3_53c,
      isSelected: widget.selectReport,
      children: textReport,
    );
  }
}

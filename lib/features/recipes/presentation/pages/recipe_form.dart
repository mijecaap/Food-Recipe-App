import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/core/presentation/widgets/title_page.dart';
import 'package:recipez/features/recipes/data/models/ingredient.dart';
import 'package:recipez/features/recipes/data/models/recipe_model.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/features/recipes/presentation/widgets/alert_dialog_ingredient.dart';
import 'package:recipez/features/recipes/presentation/widgets/input_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> list = <String>['Rápida', 'Criolla', 'China', 'Vegetariana'];

class RecipeForm extends StatefulWidget {
  final String userId;
  final String id;
  final String photoURL;
  final String title;
  final String description;
  final String person;
  final String estimatedTime;
  final String typeFood;
  final List<dynamic> ingredients;
  final List<dynamic> steps;

  const RecipeForm({
    required this.userId,
    this.id = "",
    this.photoURL = "",
    this.title = "",
    this.description = "",
    this.person = "",
    this.estimatedTime = "",
    this.typeFood = "Rápida",
    this.ingredients = const [],
    this.steps = const [],
    super.key,
  });

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  late String dropdownValue;
  List<IngredientModel> listIngredient = [];
  late List<IngredientPopupWidget> listDynamicIngredient = [];
  List<TextEditingController> listControllerStep = [];
  late List<StepWidget> listDynamicStep = [];
  final _controllerTitleRecipe = TextEditingController();
  final _controllerDescriptionRecipe = TextEditingController();
  final _controllerPersonRecipe = TextEditingController();
  final _controllerTimeRecipe = TextEditingController();
  File? image;
  late String photoURL;

  late RecipeBloc recipeBloc;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to pick image")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    photoURL = widget.photoURL;

    if (_controllerTitleRecipe.text == "")
      _controllerTitleRecipe.text = widget.title;
    if (_controllerDescriptionRecipe.text == "")
      _controllerDescriptionRecipe.text = widget.description;
    if (_controllerPersonRecipe.text == "")
      _controllerPersonRecipe.text = widget.person;
    if (_controllerTimeRecipe.text == "")
      _controllerTimeRecipe.text = widget.estimatedTime;

    dropdownValue = widget.typeFood;

    if (widget.ingredients.isEmpty && listIngredient.isEmpty) {
      listIngredient.add(IngredientModel("", "", 0, ""));
      listDynamicIngredient.add(
        IngredientPopupWidget(ingredient: listIngredient[0]),
      );
    } else if (widget.ingredients.isNotEmpty && listIngredient.isEmpty) {
      for (int i = 0; i < widget.ingredients.length; i++) {
        listIngredient.add(
          IngredientModel(
            widget.ingredients[i]["name"],
            widget.ingredients[i]["valueText"],
            widget.ingredients[i]["value"],
            widget.ingredients[i]["dimension"],
          ),
        );
        listDynamicIngredient.add(
          IngredientPopupWidget(
            ingredient: listIngredient[listIngredient.length - 1],
          ),
        );
      }
    }

    if (widget.steps.isEmpty && listControllerStep.isEmpty) {
      listControllerStep.add(TextEditingController());
      listDynamicStep.add(StepWidget(listControllerStep[0]));
    } else if (widget.steps.isNotEmpty && listControllerStep.isEmpty) {
      for (int i = 0; i < widget.steps.length; i++) {
        listControllerStep.add(TextEditingController(text: widget.steps[i]));
        listDynamicStep.add(
          StepWidget(listControllerStep[listControllerStep.length - 1]),
        );
      }
    }

    recipeBloc = BlocProvider.of(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.blanco,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
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
                  TitlePage(
                    text: widget.title == "" ? "New Recipes" : "Edit Recipes",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ContainerPhoto(
                      image: image,
                      photoURL: photoURL,
                      pickImage: pickImage,
                    ),
                    const SizedBox(height: 20),
                    InputText(
                      hintText: "Title",
                      maxLines: 1,
                      maxLength: 15,
                      textInputType: TextInputType.text,
                      textEditingController: _controllerTitleRecipe,
                    ),
                    const SizedBox(height: 20),
                    InputText(
                      hintText: "Description",
                      maxLines: 3,
                      maxLength: 255,
                      textInputType: TextInputType.text,
                      textEditingController: _controllerDescriptionRecipe,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Person(s)",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.morado_3_53c,
                            ),
                          ),
                        ),
                        Expanded(
                          child: InputText(
                            hintText: "Ex. 2 persons",
                            maxLines: 1,
                            maxLength: 1,
                            textInputType: TextInputType.number,
                            textEditingController: _controllerPersonRecipe,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Estimated time (min)",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.morado_3_53c,
                            ),
                          ),
                        ),
                        Expanded(
                          child: InputText(
                            hintText: "Ex. 120",
                            maxLines: 1,
                            maxLength: 3,
                            textInputType: TextInputType.number,
                            textEditingController: _controllerTimeRecipe,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Type of food",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.morado_3_53c,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownWidget(
                            dropdownValue: dropdownValue,
                            onValueChanged: (value) {
                              setState(() {
                                dropdownValue = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Ingredients",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColor.morado_3_53c,
                      ),
                    ),
                    ColumnIngredientsWidget(
                      listIngredient: listIngredient,
                      listDynamicIngredient: listDynamicIngredient,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Steps",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColor.morado_3_53c,
                      ),
                    ),
                    ColumnStepsWidget(
                      listControllerStep: listControllerStep,
                      listDynamicStep: listDynamicStep,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(widget.photoURL);
                        if (image == null && widget.photoURL == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please take a picture"),
                            ),
                          );
                          return;
                        }
                        if (_controllerTitleRecipe.text == '' ||
                            _controllerDescriptionRecipe.text == '' ||
                            _controllerPersonRecipe.text == '' ||
                            _controllerTimeRecipe.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please title, description, person(s) and estimated time field cannot be empty",
                              ),
                            ),
                          );
                          return;
                        }
                        final isEmptyIg = listIngredient.any(
                          (element) => element.valueText == '',
                        );
                        final isEmptySt = listControllerStep.any(
                          (element) => element.text == '',
                        );
                        if (isEmptySt || isEmptyIg) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please ingredient and step field cannot be empty",
                              ),
                            ),
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (BuildContext context) => Center(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    color: AppColor.morado_3_53c,
                                  ),
                                ),
                              ),
                        );

                        widget.title == ""
                            ? recipeBloc.uploadImage(image!).then((String url) {
                              recipeBloc
                                  .createRecipe(
                                    RecipeModel(
                                      id: '',
                                      userId: widget.userId,
                                      userName: '',
                                      userPhotoUrl: '',
                                      imageUrl: url,
                                      title:
                                          _controllerTitleRecipe.text
                                              .toLowerCase(),
                                      description:
                                          _controllerDescriptionRecipe.text
                                              .toLowerCase(),
                                      preparationTime: int.parse(
                                        _controllerTimeRecipe.text,
                                      ),
                                      portions: int.parse(
                                        _controllerPersonRecipe.text,
                                      ),
                                      difficulty: 1,
                                      steps:
                                          listControllerStep
                                              .map((e) => e.text.toLowerCase())
                                              .toList(),
                                      ingredients:
                                          listIngredient.map((e) {
                                            return {
                                              'name': e.name.toLowerCase(),
                                              'valueText': e.valueText,
                                              'value': e.value,
                                              'dimension':
                                                  e.dimension.toLowerCase(),
                                            };
                                          }).toList(),
                                      likes: [],
                                      views: 0,
                                      date: Timestamp.now(),
                                      reports: [],
                                    ),
                                  )
                                  .then((value) {
                                    Navigator.of(
                                      context,
                                    ).popUntil((route) => route.isFirst);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Successfully created"),
                                      ),
                                    );
                                  });
                            })
                            : (image != null
                                ? recipeBloc.uploadImage(image!).then((
                                  String url,
                                ) {
                                  recipeBloc
                                      .updateRecipe(
                                        RecipeModel(
                                          id: widget.id,
                                          userId: widget.userId,
                                          userName: '',
                                          userPhotoUrl: '',
                                          imageUrl: url,
                                          title:
                                              _controllerTitleRecipe.text
                                                  .toLowerCase(),
                                          description:
                                              _controllerDescriptionRecipe.text
                                                  .toLowerCase(),
                                          preparationTime: int.parse(
                                            _controllerTimeRecipe.text,
                                          ),
                                          portions: int.parse(
                                            _controllerPersonRecipe.text,
                                          ),
                                          difficulty: 1,
                                          steps:
                                              listControllerStep
                                                  .map(
                                                    (e) => e.text.toLowerCase(),
                                                  )
                                                  .toList(),
                                          ingredients:
                                              listIngredient.map((e) {
                                                return {
                                                  'name': e.name.toLowerCase(),
                                                  'valueText': e.valueText,
                                                  'value': e.value,
                                                  'dimension':
                                                      e.dimension.toLowerCase(),
                                                };
                                              }).toList(),
                                          likes: [],
                                          views: 0,
                                          date: Timestamp.now(),
                                          reports: [],
                                        ),
                                      )
                                      .then((value) {
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Successfully updated",
                                            ),
                                          ),
                                        );
                                      });
                                })
                                : recipeBloc
                                    .updateRecipe(
                                      RecipeModel(
                                        id: widget.id,
                                        userId: widget.userId,
                                        userName: '',
                                        userPhotoUrl: '',
                                        imageUrl: widget.photoURL,
                                        title:
                                            _controllerTitleRecipe.text
                                                .toLowerCase(),
                                        description:
                                            _controllerDescriptionRecipe.text
                                                .toLowerCase(),
                                        preparationTime: int.parse(
                                          _controllerTimeRecipe.text,
                                        ),
                                        portions: int.parse(
                                          _controllerPersonRecipe.text,
                                        ),
                                        difficulty: 1,
                                        steps:
                                            listControllerStep
                                                .map(
                                                  (e) => e.text.toLowerCase(),
                                                )
                                                .toList(),
                                        ingredients:
                                            listIngredient.map((e) {
                                              return {
                                                'name': e.name.toLowerCase(),
                                                'valueText': e.valueText,
                                                'value': e.value,
                                                'dimension':
                                                    e.dimension.toLowerCase(),
                                              };
                                            }).toList(),
                                        likes: [],
                                        views: 0,
                                        date: Timestamp.now(),
                                        reports: [],
                                      ),
                                    )
                                    .then((value) {
                                      Navigator.of(
                                        context,
                                      ).popUntil((route) => route.isFirst);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Successfully updated"),
                                        ),
                                      );
                                    }));

                        /*recipeBloc.uploadImage(image!)
                                .then((String url) {
                              widget.title == "" ?
                              recipeBloc.createRecipe(RecipeModel(
                                userId: widget.userId,
                                photoURL: url,
                                title: _controllerTitleRecipe.text.toLowerCase(),
                                description: _controllerDescriptionRecipe.text.toLowerCase(),
                                personQuantity: _controllerPersonRecipe.text,
                                estimatedTime: _controllerTimeRecipe.text,
                                type: dropdownValue,
                                ingredients: listIngredient.map((e) {
                                  return {
                                    'name': e.name.toLowerCase(),
                                    'valueText': e.valueText,
                                    'value': e.value,
                                    'dimension': e.dimension.toLowerCase()
                                  };
                                }).toList(),
                                steps: listControllerStep.map((e) => e.text.toLowerCase()).toList(),
                                likesUserId: [],
                                likes: 0,
                                views: 0,
                                dateCreation: DateTime.now(),
                                reports: [],
                                status: true,
                              ), widget.userId).then((value) {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Successfully created"),
                                    )
                                );
                              }) : recipeBloc.updateRecipe(RecipeModel(
                                id: widget.id,
                                userId: widget.userId,
                                photoURL: url,
                                title: _controllerTitleRecipe.text.toLowerCase(),
                                description: _controllerDescriptionRecipe.text.toLowerCase(),
                                personQuantity: _controllerPersonRecipe.text,
                                estimatedTime: _controllerTimeRecipe.text,
                                type: dropdownValue,
                                ingredients: listIngredient.map((e) {
                                  return {
                                    'name': e.name.toLowerCase(),
                                    'valueText': e.valueText,
                                    'value': e.value,
                                    'dimension': e.dimension.toLowerCase()
                                  };
                                }).toList(),
                                steps: listControllerStep.map((e) => e.text.toLowerCase()).toList(),
                                likesUserId: [],
                                likes: 0,
                                views: 0,
                                dateCreation: DateTime.now(),
                                reports: [],
                                status: true,
                              )).then((value) {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Successfully updated"),
                                    )
                                );
                              });
                            });*/
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.morado_3_53c,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          widget.title == "" ? "Publish" : "Edit",
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: AppColor.blanco,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
class IngredientPopupWidget extends StatefulWidget {
  final IngredientModel ingredient;

  const IngredientPopupWidget({required this.ingredient, super.key});

  @override
  State<IngredientPopupWidget> createState() => _IngredientPopupWidgetState();
}

class _IngredientPopupWidgetState extends State<IngredientPopupWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.ingredient.valueText == "") {
      return Expanded(
        flex: 7,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColor.morado_3_53c),
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialogIngredient(ingredient: widget.ingredient);
              },
            ).then((value) {
              setState(() {});
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 18),
            child: Text(
              "Press to add ingredient",
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: AppColor.morado_3_53c,
              ),
            ),
          ),
        ),
      );
    } else {
      List<String> aux = widget.ingredient.valueText.split("/");
      List<String> aux2 = aux.length == 1 ? [] : aux[0].split("&");
      return Expanded(
        flex: 7,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Text(
                '${aux2.isEmpty ? aux[0] : (aux2.length == 1 ? "" : (aux2[0]))} ${aux2.isEmpty ? "" : (aux2.length == 1 ? ("${aux[0]}/") : ("${aux2[1]}/"))}${aux2.isEmpty ? "" : (aux2.length == 1 ? aux[1] : aux[1])} ${widget.ingredient.dimension} ${widget.ingredient.name}',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lila_2_6be,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialogIngredient(
                        ingredient: widget.ingredient,
                      );
                    },
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Icon(Icons.edit, color: AppColor.morado_1_57a, size: 24),
              ),
            ),
          ],
        ),
      );
    }
  }
}

//ignore: must_be_immutable
class StepWidget extends StatelessWidget {
  final TextEditingController controller;

  const StepWidget(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: InputText(
        hintText: "Ex. Mix the eggs with milk",
        maxLines: 3,
        maxLength: 185,
        textInputType: TextInputType.text,
        textEditingController: controller,
      ),
    );
  }
}

class DropdownWidget extends StatefulWidget {
  final String dropdownValue;
  final Function(String) onValueChanged;

  const DropdownWidget({
    required this.dropdownValue,
    required this.onValueChanged,
    super.key,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.dropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.gris_1_8fa,
        border: InputBorder.none,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.lila_2_6be),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.morado_2_347),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      items:
          list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            currentValue = value;
          });
          widget.onValueChanged(value);
        }
      },
    );
  }
}

class ContainerPhoto extends StatefulWidget {
  final File? image;
  final String photoURL;
  final VoidCallback pickImage;

  const ContainerPhoto({
    required this.image,
    required this.photoURL,
    required this.pickImage,
    super.key,
  });

  @override
  State<ContainerPhoto> createState() => _ContainerPhotoState();
}

class _ContainerPhotoState extends State<ContainerPhoto> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256,
      width: double.infinity,
      child: Material(
        color: AppColor.lila_1_8ff,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        child: InkWell(
          onTap: widget.pickImage,
          child: Stack(
            children: [
              widget.image != null
                  ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.file(widget.image!, fit: BoxFit.cover),
                  )
                  : (widget.photoURL != ""
                      ? SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: widget.photoURL,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: AppColor.lila_1_8ff,
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                        ),
                      )
                      : Container()),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColor.lila_1_8ff.withOpacity(0.2),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 48,
                  color:
                      widget.image == null
                          ? AppColor.blanco
                          : AppColor.blanco.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColumnIngredientsWidget extends StatefulWidget {
  final List<IngredientModel> listIngredient;
  final List<IngredientPopupWidget> listDynamicIngredient;

  const ColumnIngredientsWidget({
    required this.listIngredient,
    required this.listDynamicIngredient,
    super.key,
  });

  @override
  State<ColumnIngredientsWidget> createState() =>
      _ColumnIngredientsWidgetState();
}

class _ColumnIngredientsWidgetState extends State<ColumnIngredientsWidget> {
  deleteIngredient(index) {
    if (widget.listDynamicIngredient.length == 1) return;
    widget.listIngredient.removeAt(index);
    widget.listDynamicIngredient.removeAt(index);
    setState(() {});
  }

  addIngredient() {
    if (widget.listDynamicIngredient.length > 9) return;
    widget.listIngredient.add(IngredientModel("", "", 0, ""));
    widget.listDynamicIngredient.add(
      IngredientPopupWidget(
        ingredient: widget.listIngredient[widget.listIngredient.length - 1],
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: widget.listDynamicIngredient.length,
          itemBuilder:
              (_, index) => Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.listDynamicIngredient[index],
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          deleteIngredient(index);
                        },
                        child: Icon(
                          Icons.delete,
                          color: AppColor.rojo_f59,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        widget.listDynamicIngredient.length > 9
            ? Container()
            : TextButton(
              onPressed: addIngredient,
              child: Text(
                "+ Ingredient",
                style: GoogleFonts.openSans(color: AppColor.morado_1_57a),
              ),
            ),
      ],
    );
  }
}

class ColumnStepsWidget extends StatefulWidget {
  final List<TextEditingController> listControllerStep;
  final List<StepWidget> listDynamicStep;

  const ColumnStepsWidget({
    required this.listControllerStep,
    required this.listDynamicStep,
    super.key,
  });

  @override
  State<ColumnStepsWidget> createState() => _ColumnStepsWidgetState();
}

class _ColumnStepsWidgetState extends State<ColumnStepsWidget> {
  addStep() {
    if (widget.listDynamicStep.length > 9) return;
    widget.listControllerStep.add(TextEditingController());
    widget.listDynamicStep.add(
      StepWidget(
        widget.listControllerStep[widget.listControllerStep.length - 1],
      ),
    );
    setState(() {});
  }

  deleteStep(index) {
    if (widget.listDynamicStep.length == 1) return;
    widget.listControllerStep.removeAt(index);
    widget.listDynamicStep.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: widget.listDynamicStep.length,
          itemBuilder:
              (_, index) => Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.listDynamicStep[index],
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          deleteStep(index);
                        },
                        child: Icon(
                          Icons.delete,
                          color: AppColor.rojo_f59,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        widget.listDynamicStep.length > 9
            ? Container()
            : TextButton(
              onPressed: addStep,
              child: Text(
                "+ Step",
                style: GoogleFonts.openSans(color: AppColor.morado_1_57a),
              ),
            ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/ui/widgets/input_text.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RecipeForm extends StatefulWidget {

  final String userId;

  const RecipeForm({required this.userId, Key? key}) : super(key: key);

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {

  List<TextEditingController> listControllerIngredient = [TextEditingController()];
  late List<IngredientWidget> listDynamicIngredient = [IngredientWidget(listControllerIngredient[0])];
  List<TextEditingController> listControllerStep = [TextEditingController()];
  late List<StepWidget> listDynamicStep = [StepWidget(listControllerStep[0])];
  final _controllerTitleRecipe = TextEditingController();
  final _controllerDescriptionRecipe = TextEditingController();
  final _controllerPersonRecipe = TextEditingController();
  final _controllerTimeRecipe = TextEditingController();
  File? image;

  late RecipeBloc recipeBloc;

  addIngredient() {
    if(listDynamicIngredient.length > 9) return;
    listControllerIngredient.add(TextEditingController());
    listDynamicIngredient.add(new IngredientWidget(listControllerIngredient[listControllerIngredient.length - 1]));
    setState(() {});
  }

  deleteIngredient(index) {
    if(listDynamicIngredient.length == 1) return;
    listControllerIngredient.removeAt(index);
    listDynamicIngredient.removeAt(index);
    setState(() {});
  }

  addStep() {
    if(listDynamicStep.length > 9) return;
    listControllerStep.add(TextEditingController());
    listDynamicStep.add(new StepWidget(listControllerStep[listControllerStep.length - 1]));
    setState(() {});
  }

  deleteStep(index) {
    if(listDynamicStep.length == 1) return;
    listControllerStep.removeAt(index);
    listDynamicStep.removeAt(index);
    setState(() {});
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickCamera() async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    recipeBloc = BlocProvider.of(context);

    return Scaffold(
        extendBody: true,
        backgroundColor: AppColor.blanco,
        body: SafeArea(
          child: Container(
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
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColor.morado_2_347,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const TittlePage(text: "New Recipes")
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 256,
                          width: double.infinity,
                          child: Material(
                            color: AppColor.lila_1_8ff,
                            borderRadius: BorderRadius.circular(15),
                            clipBehavior: Clip.hardEdge,
                            elevation: 5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                pickImage();
                              },
                              child: Stack(
                                children: [
                                  image != null ? SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.file(image!, fit: BoxFit.cover),
                                  ) : Container(),
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: AppColor.lila_1_8ff.withOpacity(0.2),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 48,
                                      color: image == null ? AppColor.blanco : AppColor.blanco.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InputText(
                            hintText: "Title",
                            maxLines: 1,
                            maxLength: 15,
                            textInputType: TextInputType.text,
                            textEditingController: _controllerTitleRecipe
                        ),
                        const SizedBox(height: 20),
                        InputText(
                            hintText: "Description",
                            maxLines: 3,
                            maxLength: 255,
                            textInputType: TextInputType.text,
                            textEditingController: _controllerDescriptionRecipe
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
                                    color: AppColor.morado_3_53c
                                ),
                              ),
                            ),
                            Expanded(
                              child: InputText(hintText: "Ex. 2 persons", maxLines: 1, maxLength: 1, textInputType: TextInputType.number, textEditingController: _controllerPersonRecipe),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Estimated time (min)",
                                style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.morado_3_53c
                                ),
                              ),
                            ),
                            Expanded(
                              child: InputText(hintText: "Ex. 120", maxLines: 1, maxLength: 3, textInputType: TextInputType.number, textEditingController: _controllerTimeRecipe),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Ingredients",
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColor.morado_3_53c
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: listDynamicIngredient.length,
                          itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                listDynamicIngredient[index],
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteIngredient(index);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColor.morado_3_53c,
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
                        listDynamicIngredient.length > 9 ? Container() : TextButton(
                          onPressed: addIngredient,
                          child: Text(
                            "+ Ingredient",
                            style: GoogleFonts.openSans(
                                color: AppColor.morado_1_57a
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Steps",
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColor.morado_3_53c
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: listDynamicStep.length,
                          itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.only(
                                top: 20
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                listDynamicStep[index],
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteStep(index);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColor.morado_3_53c,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        listDynamicStep.length > 9 ? Container() : TextButton(
                          onPressed: addStep,
                          child: Text(
                            "+ Step",
                            style: GoogleFonts.openSans(
                                color: AppColor.morado_1_57a
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (image == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please take a picture"),
                                  )
                              );
                              return;
                            }
                            if(
                            _controllerTitleRecipe.text == ''
                                || _controllerDescriptionRecipe == ''
                                || _controllerPersonRecipe == ''
                                || _controllerTimeRecipe == ''
                            ) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please title, description, person(s) and estimated time field cannot be empty"),
                                  )
                              );
                              return;
                            }
                            final isEmptyIg = listControllerIngredient.any((element) => element.text == '');
                            final isEmptySt = listControllerStep.any((element) => element.text == '');
                            if(isEmptySt || isEmptyIg){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please ingredient and step field cannot be empty"),
                                  )
                              );
                              return;
                            }
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => const AlertDialog(
                                  title: Text("Cargando"),
                                  content: CircularProgressIndicator(),
                                )
                            );
                            recipeBloc.uploadImage(image!)
                                .then((String url) {
                              recipeBloc.createRecipe(RecipeModel(
                                  photoURL: url,
                                  title: _controllerTitleRecipe.text,
                                  userId: widget.userId,
                                  description: _controllerDescriptionRecipe.text,
                                  personQuantity: _controllerPersonRecipe.text,
                                  estimatedTime: _controllerTimeRecipe.text,
                                  ingredients: listControllerIngredient.map((e) => e.text).toList(),
                                  steps: listControllerStep.map((e) => e.text).toList(),
                                  likesUserId: [],
                                  likes: 0,
                                  dateCreation: DateTime.now()
                              ), widget.userId).then((value) {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              });
                            });

                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 2.0,
                                  color: AppColor.secondaryColor
                              )
                          ),
                          child: Text(
                            "PUBLICAR",
                            style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: AppColor.secondaryColor
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
}

class IngredientWidget extends StatelessWidget {

  late TextEditingController controller;

  IngredientWidget(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    /*final controllerIngredientRecipe = TextEditingController();*/

    return Expanded(
      flex: 7,
      child: InputText(
          hintText: "Ex. 250g flour",
          maxLines: 1,
          maxLength: 55,
          textInputType: TextInputType.text,
          textEditingController: controller
      ),
    );
  }
}

class StepWidget extends StatelessWidget {

  late TextEditingController controller;

  StepWidget(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    /*final _controllerStepRecipe = TextEditingController();*/

    return
      Expanded(
        flex: 7,
        child: InputText(
            hintText: "Ex. Mix the eggs with milk",
            maxLines: 3,
            maxLength: 185,
            textInputType: TextInputType.text,
            textEditingController: controller
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/recipe.dart';
import 'package:recipez/Recipe/ui/widgets/input_text.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/fitted_text.dart';
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
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    recipeBloc = BlocProvider.of(context);

    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background-app.png"),
                  colorFilter: ColorFilter.mode(Color(0xff990000).withOpacity(0.8), BlendMode.modulate),
                  fit: BoxFit.cover
              )
          ),
        ),
        Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: ListView(
              padding: EdgeInsets.all(0),
              children: [
                Container(
                  height: (screenHeight / 2.5) + (screenHeight / 24),
                  width: size.width,
                  child: Stack(
                    children: [
                      Container(
                        height: screenHeight / 2.5,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(screenHeight / 96),
                                bottomRight: Radius.circular(screenHeight / 96)
                            )
                        ),
                        child: image != null ? Image.file(image!, fit: BoxFit.fill) : Icon(
                          Icons.image_outlined,
                          size: screenHeight / 6,
                          color: AppColor.fourthyColor,
                        ),
                      ),
                      SafeArea(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColor.thirdyColor,
                                size: screenHeight / 24,
                              ),
                            ),
                            SizedBox(width: screenHeight / 48),
                            FittedText(heightBox: screenHeight / 16, firstText: "New ", boldText: "Recipes",)
                          ],
                        ),
                      ),
                      Positioned(
                        right: screenHeight / 24,
                        top: screenHeight / 2.8,
                        child: Container(
                          width: screenHeight / 12,
                          height: screenHeight / 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenHeight / 24),
                          ),
                          child: Material(
                            color: AppColor.secondaryColor,
                            borderRadius: BorderRadius.circular(screenHeight / 24),
                            elevation: 10,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(screenHeight / 24),
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: screenHeight / 18,
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48
                  ),
                  child: InputText(
                      hintText: "Title",
                      maxLines: 1,
                      maxLength: 15,
                      textInputType: TextInputType.text,
                      textEditingController: _controllerTitleRecipe
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48
                  ),
                  child: InputText(
                      hintText: "Description",
                      maxLines: 3,
                      maxLength: 255,
                      textInputType: TextInputType.text,
                      textEditingController: _controllerDescriptionRecipe
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Person(s)",
                          style: GoogleFonts.openSans(
                              fontSize: screenHeight / 48,
                              fontWeight: FontWeight.w400,
                              color: AppColor.thirdyColor
                          ),
                        ),
                      ),
                      Expanded(
                        child: InputText(hintText: "Ex. 2 persons", maxLines: 1, maxLength: 1, textInputType: TextInputType.number, textEditingController: _controllerPersonRecipe),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Estimated time (min)",
                          style: GoogleFonts.openSans(
                              fontSize: screenHeight / 48,
                              fontWeight: FontWeight.w400,
                              color: AppColor.thirdyColor
                          ),
                        ),
                      ),
                      Expanded(
                        child: InputText(hintText: "Ex. 120", maxLines: 1, maxLength: 3, textInputType: TextInputType.number, textEditingController: _controllerTimeRecipe),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48
                  ),
                  child: Text(
                    "Ingredients",
                    style: GoogleFonts.openSans(
                        fontSize: screenHeight / 24,
                        fontWeight: FontWeight.w700,
                        color: AppColor.thirdyColor
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: listDynamicIngredient.length,
                  itemBuilder: (_, index) => Padding(
                    padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48,
                      top: screenHeight / 48,
                    ),
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
                            child: Icon(Icons.delete, color: AppColor.thirdyColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
                SizedBox(height: screenHeight / 96),
                Padding(
                    padding: EdgeInsets.only(
                        left: screenHeight / 48,
                        right: screenHeight / 48
                    ),
                    child: TextButton(
                      onPressed: addIngredient,
                      child: Text(
                        "+ Ingredient",
                        style: GoogleFonts.openSans(
                            color: AppColor.thirdyColor
                        ),
                      ),
                    )
                ),
                SizedBox(height: screenHeight / 96),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48
                  ),
                  child: Text(
                    "Steps",
                    style: GoogleFonts.openSans(
                        fontSize: screenHeight / 24,
                        fontWeight: FontWeight.w700,
                        color: AppColor.thirdyColor
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 96),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: listDynamicStep.length,
                  itemBuilder: (_, index) => Padding(
                    padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48,
                      top: screenHeight / 48,
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
                            child: Icon(Icons.delete, color: AppColor.thirdyColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
                SizedBox(height: screenHeight / 96),
                listDynamicStep.length > 9 ? Container() : Padding(
                    padding: EdgeInsets.only(
                        left: screenHeight / 48,
                        right: screenHeight / 48
                    ),
                    child: TextButton(
                      onPressed: addStep,
                      child: Text(
                        "+ Step",
                        style: GoogleFonts.openSans(
                            color: AppColor.thirdyColor
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight / 48,
                      right: screenHeight / 48
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      if (image == null){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Please take a picture"),
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
                            SnackBar(
                              content: const Text("Please title, description, person(s) and estimated time field cannot be empty"),
                            )
                        );
                        return;
                      }
                      final isEmptyIg = listControllerIngredient.any((element) => element.text == '');
                      final isEmptySt = listControllerStep.any((element) => element.text == '');
                      if(isEmptySt || isEmptyIg){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Please ingredient and step field cannot be empty"),
                            )
                        );
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Cargando"),
                            content: Container(
                              height: screenHeight / 24,
                              child: CircularProgressIndicator(),
                            ),
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
                    child: Text(
                      "PUBLICAR",
                      style: GoogleFonts.openSans(
                          fontSize: screenHeight / 48,
                          color: AppColor.secondaryColor
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            width: 2.0,
                            color: AppColor.secondaryColor
                        )
                    ),
                  ),
                )
              ],
            )
        ),

      ],
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
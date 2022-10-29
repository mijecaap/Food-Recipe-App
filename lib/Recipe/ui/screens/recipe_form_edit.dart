import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/model/ingredient.dart';
import 'package:recipez/Recipe/ui/widgets/alert_dialog_ingredient.dart';
import 'package:recipez/Recipe/ui/widgets/input_text.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/Shared/ui/widgets/tittle_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../model/recipe.dart';

const List<String> list = <String>['Rápida', 'Criolla', 'China', 'Vegetariana'];

class RecipeFormEdit extends StatefulWidget {

  final String userId;
  final String recipeId;

  const RecipeFormEdit({required this.userId, Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeFormEdit> createState() => _RecipeFormStateEdit();
}

class _RecipeFormStateEdit extends State<RecipeFormEdit> {

  late String dropdownValue = list.first;
  List<IngredientModel> listIngredient = [IngredientModel("", "", 0, "")];
  late List<IngredientPopupWidget> listDynamicIngredient = [IngredientPopupWidget(ingredient: listIngredient[0])];
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
    listIngredient.add(IngredientModel("", "", 0, ""));
    listDynamicIngredient.add(IngredientPopupWidget(ingredient: listIngredient[listIngredient.length - 1]));
    setState(() {});
  }

  deleteIngredient(index) {
    if(listDynamicIngredient.length == 1) return;
    listIngredient.removeAt(index);
    listDynamicIngredient.removeAt(index);
    setState(() {});
  }

  addStep() {
    if(listDynamicStep.length > 9) return;
    listControllerStep.add(TextEditingController());
    listDynamicStep.add(StepWidget(listControllerStep[listControllerStep.length - 1]));
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
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to pick image"),
          )
      );
      return;
    }
  }

  Future pickCamera() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to pick image"),
          )
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {

    recipeBloc = BlocProvider.of(context);


    return Scaffold(

      body: FutureBuilder<RecipeModel?>(

        future: recipeBloc.readRecipeById(widget.recipeId),
        builder: (context, snapshot){


          if(snapshot.hasError){
            return Text("Error");
          } else if(snapshot.hasData){
            final momentRecipe = snapshot.data;


            return momentRecipe == null

                ? Center(child: Text("No data"))
                : Scaffold(




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
                              const TittlePage(text: "Edit Recipe")
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
                                          ) : SizedBox(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Image.network(momentRecipe.photoURL, fit: BoxFit.cover),
                                          ),
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
                                        style: GoogleFonts.roboto(
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Type of food",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.morado_3_53c
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: dropdownValue,
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColor.gris_1_8fa,
                                          border: InputBorder.none,
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.lila_2_6be),
                                              borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.morado_2_347),
                                              borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                          ),
                                        ),
                                        items: list.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            dropdownValue = value!;
                                          });
                                        },
                                      ),
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
                                listDynamicStep.length > 9 ? Container() : TextButton(
                                  onPressed: addStep,
                                  child: Text(
                                    "+ Step",
                                    style: GoogleFonts.openSans(
                                        color: AppColor.morado_1_57a
                                    ),
                                  ),
                                ),

                                ElevatedButton(
                                    onPressed: () {
                                      if (image == null && momentRecipe.photoURL==""){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Please take a picture"),
                                            )
                                        );
                                        return;
                                      }
                                      if(
                                      _controllerTitleRecipe.text == ''
                                          || _controllerDescriptionRecipe.text == ''
                                          || _controllerPersonRecipe.text == ''
                                          || _controllerTimeRecipe.text == ''
                                      ) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Please title, description, person(s) and estimated time field cannot be empty"),
                                            )
                                        );
                                        return;
                                      }
                                      final isEmptyIg = listIngredient.any((element) => element.valueText == '');
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
                                          barrierDismissible: false,
                                          builder: (BuildContext context) => Center(
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: CircularProgressIndicator(
                                                color: AppColor.morado_3_53c,
                                              ),
                                            ),
                                          )
                                      );

                                      if(image==null){
                                        recipeBloc.updateRecipeData(RecipeModel(
                                            photoURL: momentRecipe.photoURL,
                                            title: _controllerTitleRecipe.text,
                                            userId: widget.userId,
                                            description: _controllerDescriptionRecipe.text,
                                            personQuantity: _controllerPersonRecipe.text,
                                            estimatedTime: _controllerTimeRecipe.text,
                                            ingredients: listIngredient.map((e) {
                                              return {
                                                'name': e.name,
                                                'valueText': e.valueText,
                                                'value': e.value,
                                                'dimension': e.dimension
                                              };
                                            }).toList(),
                                            steps: listControllerStep.map((e) => e.text).toList(),
                                            likesUserId: [],
                                            likes: 0,
                                            dateCreation: DateTime.now()
                                        ), widget.recipeId).then((value) {
                                          Navigator.of(context).popUntil((route) => route.isFirst);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("Successfully edited"),
                                              )
                                          );
                                        });
                                      }else{
                                        recipeBloc.uploadImage(image!)
                                            .then((String url) {
                                          recipeBloc.updateRecipeData(RecipeModel(
                                              photoURL: url,
                                              title: _controllerTitleRecipe.text,
                                              userId: widget.userId,
                                              description: _controllerDescriptionRecipe.text,
                                              personQuantity: _controllerPersonRecipe.text,
                                              estimatedTime: _controllerTimeRecipe.text,
                                              ingredients: listIngredient.map((e) {
                                                return {
                                                  'name': e.name,
                                                  'valueText': e.valueText,
                                                  'value': e.value,
                                                  'dimension': e.dimension
                                                };
                                              }).toList(),
                                              steps: listControllerStep.map((e) => e.text).toList(),
                                              likesUserId: [],
                                              likes: 0,
                                              dateCreation: DateTime.now()
                                          ), widget.recipeId).then((value) {
                                            Navigator.of(context).popUntil((route) => route.isFirst);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Successfully edited"),
                                                )
                                            );
                                          });
                                        });
                                      }




                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: AppColor.morado_3_53c
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                                      child: Text(
                                        "EDITAR",
                                        style: GoogleFonts.openSans(
                                            fontSize: 16,
                                            color: AppColor.blanco
                                        ),
                                      ),
                                    )
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                )
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }


          /* Scaffold de edicion
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
                            const TittlePage(text: "Edit Recipe")
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
                                  textEditingController: _controllerTitleRecipe,


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
                                      style: GoogleFonts.roboto(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Type of food",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.morado_3_53c
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: dropdownValue,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColor.gris_1_8fa,
                                        border: InputBorder.none,
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: AppColor.lila_2_6be),
                                            borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: AppColor.morado_2_347),
                                            borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                        ),
                                      ),
                                      items: list.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                    ),
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
                              listDynamicStep.length > 9 ? Container() : TextButton(
                                onPressed: addStep,
                                child: Text(
                                  "+ Step",
                                  style: GoogleFonts.openSans(
                                      color: AppColor.morado_1_57a
                                  ),
                                ),
                              ),
                              ElevatedButton(
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
                                        || _controllerDescriptionRecipe.text == ''
                                        || _controllerPersonRecipe.text == ''
                                        || _controllerTimeRecipe.text == ''
                                    ) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Please title, description, person(s) and estimated time field cannot be empty"),
                                          )
                                      );
                                      return;
                                    }
                                    final isEmptyIg = listIngredient.any((element) => element.valueText == '');
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
                                        barrierDismissible: false,
                                        builder: (BuildContext context) => Center(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator(
                                              color: AppColor.morado_3_53c,
                                            ),
                                          ),
                                        )
                                    );




                                    recipeBloc.uploadImage(image!)
                                        .then((String url) {
                                      recipeBloc.updateRecipeData(RecipeModel(
                                          photoURL: url,
                                          title: _controllerTitleRecipe.text,
                                          userId: widget.userId,
                                          description: _controllerDescriptionRecipe.text,
                                          personQuantity: _controllerPersonRecipe.text,
                                          estimatedTime: _controllerTimeRecipe.text,
                                          ingredients: listIngredient.map((e) {
                                            return {
                                              'name': e.name,
                                              'valueText': e.valueText,
                                              'value': e.value,
                                              'dimension': e.dimension
                                            };
                                          }).toList(),
                                          steps: listControllerStep.map((e) => e.text).toList(),
                                          likesUserId: [],
                                          likes: 0,
                                          dateCreation: DateTime.now()
                                      ), widget.recipeId).then((value) {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Successfully edited"),
                                            )
                                        );
                                      });
                                    });

                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColor.morado_3_53c
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text(
                                      "EDITAR",
                                      style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          color: AppColor.blanco
                                      ),
                                    ),
                                  )
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      ],
                    )
                ),
              )
          );

          */

        },

      ),


    );

    /* Scaffold original

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
                      const TittlePage(text: "Edit Recipe")
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
                                style: GoogleFonts.roboto(
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Type of food",
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.morado_3_53c
                                ),
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: dropdownValue,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColor.gris_1_8fa,
                                  border: InputBorder.none,
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.lila_2_6be),
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.morado_2_347),
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                  ),
                                ),
                                items: list.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                },
                              ),
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
                        listDynamicStep.length > 9 ? Container() : TextButton(
                          onPressed: addStep,
                          child: Text(
                            "+ Step",
                            style: GoogleFonts.openSans(
                                color: AppColor.morado_1_57a
                            ),
                          ),
                        ),
                        ElevatedButton(
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
                                  || _controllerDescriptionRecipe.text == ''
                                  || _controllerPersonRecipe.text == ''
                                  || _controllerTimeRecipe.text == ''
                              ) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please title, description, person(s) and estimated time field cannot be empty"),
                                    )
                                );
                                return;
                              }
                              final isEmptyIg = listIngredient.any((element) => element.valueText == '');
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
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => Center(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        color: AppColor.morado_3_53c,
                                      ),
                                    ),
                                  )
                              );
                              recipeBloc.uploadImage(image!)
                                  .then((String url) {
                                recipeBloc.updateRecipeData(RecipeModel(
                                    photoURL: url,
                                    title: _controllerTitleRecipe.text,
                                    userId: widget.userId,
                                    description: _controllerDescriptionRecipe.text,
                                    personQuantity: _controllerPersonRecipe.text,
                                    estimatedTime: _controllerTimeRecipe.text,
                                    ingredients: listIngredient.map((e) {
                                      return {
                                        'name': e.name,
                                        'valueText': e.valueText,
                                        'value': e.value,
                                        'dimension': e.dimension
                                      };
                                    }).toList(),
                                    steps: listControllerStep.map((e) => e.text).toList(),
                                    likesUserId: [],
                                    likes: 0,
                                    dateCreation: DateTime.now()
                                ), widget.recipeId).then((value) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Successfully edited"),
                                      )
                                  );
                                });
                              });

                            },
                            style: ElevatedButton.styleFrom(
                                primary: AppColor.morado_3_53c
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              child: Text(
                                "EDITAR",
                                style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: AppColor.blanco
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              )
          ),
        )
    );

    */

  }
}

//ignore: must_be_immutable
class IngredientPopupWidget extends StatefulWidget {

  late IngredientModel ingredient;

  IngredientPopupWidget({required this.ingredient, Key? key}) : super(key: key);

  @override
  State<IngredientPopupWidget> createState() => _IngredientPopupWidgetState();
}

class _IngredientPopupWidgetState extends State<IngredientPopupWidget> {
  @override
  Widget build(BuildContext context) {
    if(widget.ingredient.valueText == "") {
      return Expanded(
        flex: 7,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: AppColor.morado_3_53c
              )
          ),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialogIngredient(ingredient: widget.ingredient);
                }
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
                    color: AppColor.lila_2_6be
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
                        return AlertDialogIngredient(ingredient: widget.ingredient);
                      }
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Icon(
                  Icons.edit,
                  color: AppColor.morado_1_57a,
                  size: 24,
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}

//ignore: must_be_immutable
class StepWidget extends StatelessWidget {

  late TextEditingController controller;

  StepWidget(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
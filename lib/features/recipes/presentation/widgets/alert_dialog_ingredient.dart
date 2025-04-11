import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/features/recipes/data/models/ingredient.dart';
import 'package:recipez/features/recipes/presentation/widgets/input_text.dart';

const List<String> list = <String>['g', 'ml', 'und', 'cdta', 'cda', 'taza'];

class AlertDialogIngredient extends StatefulWidget {
  final IngredientModel ingredient;

  const AlertDialogIngredient({required this.ingredient, super.key});

  @override
  State<AlertDialogIngredient> createState() => _AlertDialogIngredientState();
}

class _AlertDialogIngredientState extends State<AlertDialogIngredient> {
  late List<String> aux = widget.ingredient.valueText != ""
      ? widget.ingredient.valueText.split("/")
      : [];
  late List<String> aux2 = aux.length == 1
      ? []
      : (widget.ingredient.valueText != "" ? aux[0].split("&") : []);
  final _formKey = GlobalKey<FormState>();
  late TextEditingController integer = TextEditingController(
      text: widget.ingredient.valueText != ""
          ? (aux2.isEmpty ? aux[0] : (aux2.length == 1 ? "" : (aux2[0])))
          : "");
  late TextEditingController numerator = TextEditingController(
      text: widget.ingredient.valueText != ""
          ? (aux2.isEmpty ? "" : (aux2.length == 1 ? aux[0] : aux2[1]))
          : "");
  late TextEditingController denominator = TextEditingController(
      text: widget.ingredient.valueText != ""
          ? (aux2.isEmpty ? "" : (aux2.length == 1 ? aux[1] : aux[1]))
          : "");
  late TextEditingController ingredientController = TextEditingController(
      text: widget.ingredient.name != "" ? widget.ingredient.name : "");
  late String dropdownValue = widget.ingredient.dimension == ""
      ? list.first
      : widget.ingredient.dimension;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 55,
                    child: TextFormField(
                      controller: integer,
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        filled: true,
                        counterText: '',
                        fillColor: AppColor.gris_1_8fa,
                        border: InputBorder.none,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.lila_2_6be),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.morado_2_347),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: numerator,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.gris_1_8fa,
                            counterText: '',
                            hintText: '-',
                            border: InputBorder.none,
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.lila_2_6be),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.morado_2_347),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0))),
                          ),
                        ),
                        Divider(
                            height: 20,
                            color: AppColor.morado_3_53c,
                            thickness: 1),
                        TextFormField(
                          controller: denominator,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.gris_1_8fa,
                            counterText: '',
                            hintText: '-',
                            border: InputBorder.none,
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.lila_2_6be),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.morado_2_347),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: dropdownValue,
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.gris_1_8fa,
                        border: InputBorder.none,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.lila_2_6be),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.morado_2_347),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
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
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InputText(
                  hintText: "Ex. Flour",
                  maxLines: 1,
                  maxLength: 20,
                  textInputType: TextInputType.text,
                  textEditingController: ingredientController),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColor.rojo_f59)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          widget.ingredient.valueText == ""
                              ? "Close"
                              : "Cancel",
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.rojo_f59)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.morado_3_53c),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (ingredientController.text == "") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Enter ingredient name"),
                            ));
                            return;
                          }
                          if (numerator.text == "" &&
                              denominator.text == "" &&
                              integer.text == "") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Quantity cannot be empty"),
                            ));
                            return;
                          }
                          _formKey.currentState!.save();
                          widget.ingredient.dimension = dropdownValue;
                          widget.ingredient.name = ingredientController.text;
                          if (numerator.text == "" && denominator.text == "") {
                            if (int.parse(integer.text) == 0) {
                              print('integer.text');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("An integer value cannot be 0"),
                              ));
                              return;
                            }
                            widget.ingredient.valueText = integer.text;
                            widget.ingredient.value =
                                double.parse(integer.text);
                          } else {
                            if ((numerator.text == '0') ||
                                (denominator.text == '0')) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Numerator or denominator cannot be zero, if the amount you want to enter is integer, leave the spaces empty"),
                              ));
                              return;
                            } else if (int.parse(numerator.text) >
                                int.parse(denominator.text)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Numerator is less than denominator"),
                              ));
                              return;
                            } else if (int.parse(numerator.text) ==
                                int.parse(denominator.text)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Numerator cannot be equal to the denominator"),
                              ));
                              return;
                            } else {
                              if (integer.text == "") {
                                widget.ingredient.valueText =
                                    '${numerator.text}/${denominator.text}';
                                widget.ingredient.value =
                                    double.parse(numerator.text) /
                                        double.parse(denominator.text);
                              } else {
                                if (int.parse(integer.text) == 0) {
                                  print('integer.text');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("An integer value cannot be 0"),
                                  ));
                                  return;
                                }
                                widget.ingredient.valueText =
                                    '${integer.text}&${numerator.text}/${denominator.text}';
                                widget.ingredient.value =
                                    double.parse(integer.text) *
                                        double.parse(numerator.text) /
                                        double.parse(denominator.text);
                              }
                            }
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                          widget.ingredient.valueText == "" ? "Add" : "Update",
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.blanco)),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

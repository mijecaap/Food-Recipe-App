import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class InputText extends StatefulWidget {
  final String hintText;
  final int maxLines;
  final int maxLength;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  const InputText({
    required this.hintText,
    required this.maxLines,
    required this.maxLength,
    required this.textInputType,
    required this.textEditingController,
    Key? key}) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {

  onChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      style: GoogleFonts.openSans(
        color: AppColor.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
          filled: true,
          counterText: '',
          fillColor: AppColor.fourthyColor,
          hintText: widget.hintText,
          border: InputBorder.none,
          isDense: true,
          suffixText: widget.textEditingController.text.length.toString() + " / " + widget.maxLength.toString(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fourthyColor),
              borderRadius: BorderRadius.all(Radius.circular(9.0))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(9.0))
          ),
      ),
      onChanged: (val) {
        setState(() {});
      },
    );
  }
}

/*class InputText extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final int maxLength;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  const InputText({
    required this.hintText,
    required this.maxLines,
    required this.maxLength,
    required this.textInputType,
    required this.textEditingController,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      maxLines: maxLines,
      maxLength: maxLength,
      style: GoogleFonts.openSans(
        color: AppColor.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.fourthyColor,
          counterStyle: GoogleFonts.openSans(
            color: AppColor.thirdyColor
          ),
          hintText: hintText,
          border: InputBorder.none,
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.fourthyColor),
              borderRadius: BorderRadius.all(Radius.circular(9.0))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(9.0))
          )
      ),
    );
  }
}*/

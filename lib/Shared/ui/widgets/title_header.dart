import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleHeader extends StatelessWidget {

  String firstText;
  String boldText;
  String secondText;

  TitleHeader(this.firstText, this.boldText, this.secondText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Text(
          '$firstText ',
          style: GoogleFonts.openSans(
              fontSize: 32.0
          ),
        ),
        Text(
          boldText + (secondText == '' ? '' : ' '),
          style: GoogleFonts.openSans(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
        Text(
          secondText,
          style: GoogleFonts.openSans(fontSize: 32.0),
        )
      ],
    );
  }

}
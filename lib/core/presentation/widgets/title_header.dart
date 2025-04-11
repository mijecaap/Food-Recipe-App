import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleHeader extends StatelessWidget {
  final String firstText;
  final String boldText;
  final String secondText;

  const TitleHeader(this.firstText, this.boldText, this.secondText,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$firstText ',
          style: GoogleFonts.openSans(fontSize: 32.0),
        ),
        Text(
          boldText + (secondText == '' ? '' : ' '),
          style:
              GoogleFonts.openSans(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
        Text(
          secondText,
          style: GoogleFonts.openSans(fontSize: 32.0),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_color.dart';

class TitlePage extends StatelessWidget {
  final String text;
  const TitlePage({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
          color: AppColor.morado_2_347,
          fontWeight: FontWeight.w500,
          fontSize: 30),
      overflow: TextOverflow.ellipsis,
    );
  }
}

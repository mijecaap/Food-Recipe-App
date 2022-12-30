import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class TittlePage extends StatelessWidget {
  final String text;
  const TittlePage({
    required this.text,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
          color: AppColor.morado_2_347,
          fontWeight: FontWeight.w500,
          fontSize: 30
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_color.dart';

class SubtitleButton extends StatelessWidget {
  final String text;

  const SubtitleButton({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColor.morado_2_347),
        ),
      ],
    );
  }
}

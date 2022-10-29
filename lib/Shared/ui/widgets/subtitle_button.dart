import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class SubtitleButton extends StatelessWidget {

  final String text;

  const SubtitleButton({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor.morado_2_347
          ),
        ),
        /*Icon(
          Icons.arrow_forward,
          size: 20,
          color: AppColor.morado_2_347,
        )*/
      ],
    );

  }

}
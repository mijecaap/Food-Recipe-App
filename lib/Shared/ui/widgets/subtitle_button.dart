import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class SubtitleButton extends StatelessWidget {

  final String colorText;
  final String secondText;

  const SubtitleButton({required this.colorText, required this.secondText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);

    return Row(
      children: [
        Text(
          colorText,
          style: GoogleFonts.openSans(
            fontSize: screenHeight / 24,
            fontWeight: FontWeight.bold,
            color: AppColor.secondaryColor
          ),
        ),
        Text(
          secondText,
          style: GoogleFonts.openSans(
            fontSize: screenHeight / 24,
            fontWeight: FontWeight.bold,
            color: AppColor.thirdyColor
          ),
        ),
        const Spacer(),
        Icon(
          Icons.arrow_forward,
          size: screenHeight / 24,
          color: AppColor.thirdyColor,
        )
      ],
    );

  }

}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class FittedText extends StatelessWidget {
  final double heightBox;
  final String firstText;
  final String? boldText;
  final String? secondText;
  const FittedText({
    required this.heightBox,
    required this.firstText,
    this.boldText,
    this.secondText,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightBox,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          children: [
            Text(
              '$firstText',
              style: GoogleFonts.openSans(
                color: AppColor.thirdyColor
              ),
            ),
            Text(
              boldText == null ? '' : '$boldText',
              style: GoogleFonts.openSans(
                color: AppColor.thirdyColor,
                fontWeight: FontWeight.w700
              ),
            ),
            Text(
              secondText == null ? '' : '$secondText',
              style: GoogleFonts.openSans(
                  color: AppColor.thirdyColor
              ),
            )
          ],
        ),
      ),
    );
  }
}

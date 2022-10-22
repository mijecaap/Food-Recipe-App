import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class SearchInput extends StatelessWidget {

  String placeHolder;

  SearchInput(this.placeHolder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final searchInput = Container(
      margin: const EdgeInsets.only(
          top: 16.0,
          bottom: 16.0
      ),
      decoration: BoxDecoration(
          color: AppColor.fourthyColor,
          borderRadius: BorderRadius.circular(32.0)
      ),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: placeHolder,

            hintStyle: GoogleFonts.openSans(
              fontSize: 16.0,
            ),
            contentPadding: const EdgeInsets.all(16.0),
            prefixIcon: const Icon(Icons.search, size: 16.0)
        ),
      ),
    );

    return Container(
      color: Colors.transparent,
      child: searchInput,
    );
  }

}